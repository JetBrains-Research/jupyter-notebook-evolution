
# Observing Fine-Grained Changes in Jupyter Notebooks During Development Time

[![Research](https://jb.gg/badges/research-plastic.svg)](https://github.com/JetBrains-Research)
[![Paper](https://img.shields.io/badge/Paper-JSS%202026-blue)](https://doi.org/10.1016/j.jss.2026.112983)
[![Dataset on Hugging Face](https://img.shields.io/badge/%F0%9F%A4%97%20Dataset-JuNE-yellow)](https://huggingface.co/datasets/JetBrains-Research/JuNE)
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.20669481.svg)](https://zenodo.org/records/20669481)

> 📦 **Dataset:** the **JuNE** (Jupyter Notebooks Executions) dataset is available on Hugging Face: **[JetBrains-Research/JuNE](https://huggingface.co/datasets/JetBrains-Research/JuNE)**

## 📖 Table of Contents

- [Overview](#-overview)
- [Key Contributions](#-key-contributions)
- [Repository Structure](#-repository-structure)
- [Quick Start](#-quick-start)
- [Reproducing the Analysis](#-reproducing-the-analysis)
  - [RQ1: Nature of Code Changes](#rq1-nature-of-code-changes)
  - [RQ2: Purposes of Code Changes](#rq2-purposes-of-code-changes)
  - [RQ3: Data Science Workflow Steps](#rq3-data-science-workflow-steps)
- [Tooling](#-tooling)
  - [Activity Plugin](#activity-plugin)
  - [Log Collection Server](#log-collection-server)
  - [Notebook Replay Tool](#notebook-replay-tool)
- [Model Training](#-model-training)
- [GPT-based Annotations](#-gpt-based-annotations)
- [Data Collection Details](#-data-collection-details)
- [Data Model](#-data-model)
- [Citation](#-citation)
- [Contact](#-contact)

---

## 🔬 Overview

This repository provides the complete reproducibility package for our research on fine-grained analysis of Jupyter notebook development. Unlike previous studies that analyze notebooks from VCS snapshots, we capture and analyze the real-time development process — every cell creation, execution, modification, and deletion.

### Research Questions

Our empirical analysis addresses three research questions:

|   RQ    | Question                                                                         | Key Finding                                                                                                                                |
|:-------:|----------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------|
| **RQ1** | How do code changes take place during cell development in Jupyter Notebooks?     | 39% of transitions are self-transitions (re-executions); changes are small (~13% of cell size) and decrease over consecutive re-executions |
| **RQ2** | What are the purposes of these code changes?                                     | 72.2% of changes are for code iteration (fixing, debugging, editing); only 14.1% for exploration                                           |
| **RQ3** | How are the data science workflow steps represented during notebook development? | Data exploration and preprocessing dominate (61% for DA, 35% for ML tasks); steps are highly stable within cells                           |


## 🎯 Key Contributions

### 1. Tooling for Fine-Grained Log Collection

| Component                   | Description                                                                                     | Location                                                     |
|-----------------------------|-------------------------------------------------------------------------------------------------|--------------------------------------------------------------|
| **Activity Plugin**         | JavaScript extension for Jupyter Notebook Web that tracks cell executions, creations, deletions | [`jupyter-notebook-hackathon/`](jupyter-notebook-hackathon/) |
| **Log Server**              | Flask-based server receiving and storing events in SQLite                                       | [`server/`](server/)                                         |
| **Post-processing Scripts** | Transform raw logs into analyzable tables                                                       | [`analysis/dataset/`](analysis/dataset/)                     |
| **Replay Tool**             | Browse notebook versions step-by-step in Docker                                                 | [`notebook_reproduction/`](notebook_reproduction/)           |

### 2. JuNE Dataset

The **Jupyter Notebooks Executions (JuNE)** dataset — the first dataset of fine-grained execution logs for Jupyter notebooks. Download it from [Hugging Face](https://huggingface.co/datasets/JetBrains-Research/JuNE):

- **14,641** user events
- **9,207** cell executions  
- **2,655** unique cells
- **1,930** cell creations
- **730** cell deletions

### 3. Empirical Findings

- Most changes are small (~13% of cell size) and iterative
- 72.2% of code changes are for iteration (fix, debug, edit)
- Data exploration and preprocessing dominate the workflow
- Data science steps rarely change within a single cell

---

## 📁 Repository Structure

```
package/
├── data/                              # Processed dataset artifacts
│   ├── dataset.csv                       # Main event log (actions, sources, outputs)
│   ├── labels_mapping.csv                # Action ID → Data science step labels
│   ├── labels_mapping_catboost.csv       # Labels from CatBoost classifier
│   ├── graph_evolution.csv               # Evolution graph data
│   └── sample_overview.csv               # Participant/task metadata
│
├── analysis/                          # Analysis notebooks and scripts
│   ├── 00-dataset-example.ipynb          # Dataset walkthrough
│   ├── 01-sample-analysis.ipynb          # Descriptive exploration
│   ├── 02-time-analysis.ipynb            # Time/execution analysis (RQ1)
│   ├── 03-graph-analysis.ipynb           # Evolution graphs (RQ1)
│   ├── 04-0-workflow-labels-analysis.ipynb    # Workflow labels (RQ3)
│   ├── 04-1-workflow-transitions-analysis.ipynb # Workflow transitions (RQ3)
│   ├── 04-2-workflow-transitions-analysis-new-model.ipynb
│   ├── 04-3-workflow-labels-analysis-new-model.ipynb
│   ├── 05-code-evolution-analysis.ipynb  # Code evolution metrics
│   ├── data_config.yaml                  # Path configurations
│   ├── dataset/                          # JuNE dataset abstractions
│   │   └── june_dataset.py               # JuNEDataset class
│   ├── metrics/                          # Metric implementations
│   │   ├── metrics_base.py               # Base metrics class
│   │   ├── metrics_cells.py              # Cell-level metrics
│   │   ├── metrics_graph.py              # Graph metrics
│   │   ├── metrics_time.py               # Temporal metrics
│   │   └── metrics_transtions.py         # Transition metrics
│   └── figures/                          # Generated figures
│       ├── evolution/                    # Evolution analysis figures
│       ├── graphs/                       # Graph visualizations
│       ├── transitions/                  # Transition matrices
│       └── workflow/                     # Workflow step figures
│
├── server/                            # Log collection server
│   ├── app.py                            # Flask application
│   ├── app_config.yaml                   # Server configuration
│   ├── db_structures.py                  # SQLAlchemy models
│   └── templates/
│       └── db_template.html              # HTML view for logs
│
├── gpt_annotation/                    # GPT-4o annotations (RQ2)
│   ├── prompt.txt                        # System/user prompts
│   └── GPT_annotations.json              # Annotated transitions
│
├── model_training/                    # Workflow step classifier (RQ3)
│   ├── training_pipeline.ipynb           # Training notebook
│   ├── model_inference.ipynb             # Inference notebook
│   ├── weights/
│   │   └── catboost_model                # Trained model
│   └── data/
│       ├── processed/                    # Processed training data
│       └── *.pkl                         # Feature files
│
├── notebook_reproduction/             # Notebook replay tool
│   ├── reproduce_notebook.py             # CLI entrypoint
│   ├── check_env.py                      # Environment checker
│   ├── notebook_runner/
│   │   ├── runner.py                     # NotebookRunner class
│   │   └── selenium_notebook.py          # Selenium driver
│   └── remote_environment/
│       ├── Dockerfile                    # Docker image
│       ├── requirements.txt              # Python deps
│       └── *.ipynb                       # Test notebooks
│
├── jupyter-notebook-hackathon/        # Hackathon materials
│   ├── README.md                         # Plugin installation guide
│   ├── task1.md                          # Data Analysis task
│   ├── task2.md                          # Machine Learning task
│   ├── task1.ipynb                       # DA task starter
│   ├── task2.ipynb                       # ML task starter
│   ├── setup_environment.sh              # Setup script
│   └── data/                             # Task datasets
│
├── pyproject.toml                        # Poetry configuration
├── poetry.lock                           # Locked dependencies
└── README.md                             # This file
```

---

## 🚀 Quick Start

### Prerequisites

| Requirement  | Version  | Notes                                                                 |
|--------------|----------|-----------------------------------------------------------------------|
| **Python**   | 3.11+    | Configured in [`pyproject.toml`](pyproject.toml)                      |
| **Poetry**   | Latest   | [Installation guide](https://python-poetry.org/docs/#installation)    |
| **Graphviz** | Optional | For graph visualizations ([download](https://graphviz.org/download/)) |

### Installation

```bash
# Clone the repository

# Install base dependencies
poetry install

# For full functionality (server, model training, notebook replay)
poetry install --with server,model-training,notebook-reproduction
```

### Run Analysis Notebooks

```bash
# Start Jupyter
poetry run jupyter
```

Then navigate to the [`analysis/`](analysis/) folder and run notebooks in order.

---

## 🔬 Reproducing the Analysis

> ⚠️ **Note on excluded files:** due to their size, some large files are not stored in this repository (they are listed in [`.gitignore`](.gitignore)): the CodeBERT embeddings CSV (`model_training/data/processed/codebert_hackathon_cell_source_embeddings.csv`), the extracted notebook-replay logs (`notebook_reproduction/remote_environment/data/task1/jetnet_logs.txt` and `unzip/`), and the pre-computed feature files (`*.pkl`). They are available in the [Zenodo package](https://zenodo.org/records/20669481). `jetnet_logs.zip` is kept in the repo and can be extracted to regenerate the logs.

| Notebook                                                                                                            | Research Question | Description                           |
|---------------------------------------------------------------------------------------------------------------------|-------------------|---------------------------------------|
| [`00-dataset-example.ipynb`](analysis/00-dataset-example.ipynb)                                                     | —                 | Dataset walkthrough and sanity checks |
| [`01-sample-analysis.ipynb`](analysis/01-sample-analysis.ipynb)                                                     | —                 | Descriptive statistics                |
| [`02-time-analysis.ipynb`](analysis/02-time-analysis.ipynb)                                                         | RQ1               | Temporal analysis                     |
| [`03-graph-analysis.ipynb`](analysis/03-graph-analysis.ipynb)                                                       | RQ1               | Evolution graph construction          |
| [`04-0-workflow-labels-analysis.ipynb`](analysis/04-0-workflow-labels-analysis.ipynb)                               | RQ3               | Workflow step distribution            |
| [`04-1-workflow-transitions-analysis.ipynb`](analysis/04-1-workflow-transitions-analysis.ipynb)                     | RQ3               | Transition matrices                   |
| [`04-2-workflow-transitions-analysis-new-model.ipynb`](analysis/04-2-workflow-transitions-analysis-new-model.ipynb) | RQ3               | Transitions (CatBoost model)          |
| [`04-3-workflow-labels-analysis-new-model.ipynb`](analysis/04-3-workflow-labels-analysis-new-model.ipynb)           | RQ3               | Labels (CatBoost model)               |
| [`05-code-evolution-analysis.ipynb`](analysis/05-code-evolution-analysis.ipynb)                                     | RQ1/RQ2           | Code evolution metrics                |


## 🛠️ Tooling

### Activity Plugin

The JavaScript plugin for Jupyter Notebook Web application tracks:

| Event               | Description              |
|---------------------|--------------------------|
| `execute`           | Cell execution started   |
| `finished_execute`  | Cell execution completed |
| `create`            | New cell created         |
| `delete`            | Cell deleted             |
| `rendered`          | Markdown cell rendered   |
| `error`             | Execution error occurred |
| `save_notebook`     | Notebook saved           |
| `kernel_restarting` | Kernel restart triggered |

**Installation and setup:** See [`jupyter-notebook-hackathon/README.md`](jupyter-notebook-hackathon/README.md)

```bash
cd jupyter-notebook-hackathon

# Create virtual environment
virtualenv hackathon_env
source hackathon_env/bin/activate

# Install dependencies and plugin
bash setup_environment.sh

# Or manually:
pip install -r requirements.txt
jupyter nbextension install --py mining_extension --user
jupyter nbextension enable --py mining_extension --user
```

### Log Collection Server

Flask-based server that receives plugin events via HTTP POST and stores them in SQLite.

**Configuration:** [`server/app_config.yaml`](server/app_config.yaml)

```yaml
database_rel_path: ../data/test_db.db
host: "0.0.0.0"
port: 9999
```

**Running the server:**

```bash
poetry install --with server
poetry run run_server
```

**Endpoints:**

| Method | Path | Description |
|--------|------|-------------|
| `POST` | `/` | Receive and store event JSON |
| `GET` | `/db` | HTML view of collected logs |

**Database schema:** See [`server/db_structures.py`](server/db_structures.py)

```python
class UserLogs:
    id: int              # Primary key
    ip_address: str      # Client IP
    time: str            # Timestamp
    session_id: str      # Browser session
    kernel_id: str       # Jupyter kernel
    notebook_name: str   # Notebook filename
    event: str           # Event type
    cell_index: str      # Cell unique ID
    cell_num: int        # Cell position
    cell_type: str       # 'code' or 'markdown'
    cell_source: str     # Cell content
    cell_output: str     # Execution output (JSON)
```

### Notebook Replay Tool

Reproduce a recorded notebook session step-by-step in a fresh Jupyter environment using Docker and Selenium.

**Prerequisites:**

| Requirement            | Notes                                               |
|------------------------|-----------------------------------------------------|
| Docker                 | [Installation](https://docs.docker.com/get-docker/) |
| `CHROMIUM_DRIVER_PATH` | Environment variable pointing to chromedriver       |

**Setup:**

```bash
# Build Docker image
docker build -t agent-jupyter-interaction-docker-image notebook_reproduction/remote_environment

# Prepare dataset (tool expects specific path)
mkdir -p data/local_data
cp data/dataset.csv data/local_data/

# Set ChromeDriver path
export CHROMIUM_DRIVER_PATH="/path/to/chromedriver"
```

**Running a replay:**

```bash
poetry install --with notebook-reproduction
poetry run python notebook_reproduction/reproduce_notebook.py \
    --kernel_id "<KERNEL_ID>" \
    --notebook_port 2222
```

The `kernel_id` identifies a unique notebook session from [`data/dataset.csv`](data/dataset.csv).

**Key components:**
- [`notebook_reproduction/reproduce_notebook.py`](notebook_reproduction/reproduce_notebook.py) — CLI entry point
- [`notebook_reproduction/notebook_runner/runner.py`](notebook_reproduction/notebook_runner/runner.py) — `NotebookRunner` class
- [`notebook_reproduction/notebook_runner/selenium_notebook.py`](notebook_reproduction/notebook_runner/selenium_notebook.py) — Selenium driver

---

## 🧠 Model Training

The workflow step classifier uses **CodeBERT** embeddings with a **CatBoost** classifier.

### Training Pipeline

```bash
poetry install --with model-training
poetry run jupyter
# Open model_training/training_pipeline.ipynb
```

**Key parameters:**

| Parameter | Value |
|-----------|-------|
| Embeddings | CodeBERT (via sentence-transformers) |
| Classifier | CatBoost |
| Iterations | 400 |
| Learning Rate | 0.2 |
| Evaluation Metric | Weighted F1 |
| Cross-Validation | 5-fold stratified |

**Performance:**

| Metric | Our Model | Original DASWOW |
|--------|:---------:|:---------------:|
| F1 Score | **0.721** | 0.71 |

**Artifacts:**
- [`model_training/weights/catboost_model`](model_training/weights/catboost_model) — Trained model
- [`model_training/data/processed/`](model_training/data/processed/) — Processed features
- [`model_training/catboost_info/`](model_training/catboost_info/) — Training logs

### Inference

```bash
# Open model_training/model_inference.ipynb
# Or use the trained model directly:
```

```python
from catboost import CatBoostClassifier

model = CatBoostClassifier()
model.load_model('model_training/weights/catboost_model')
predictions = model.predict(features)
```

---

## 📖 Citation

### Paper

```bibtex
@article{10.1016/j.jss.2026.112983,
author = {Titov, Sergey and Grotov, Konstantin and Sarasua, Cristina and Golubev, Yaroslav and Ramasamy, Dhivyabharathi and Bacchelli, Alberto and Bernstein, Abraham and Bryksin, Timofey},
title = {Observing fine-grained changes in Jupyter notebooks during development time},
year = {2026},
issue_date = {Nov 2026},
publisher = {Elsevier Science Inc.},
address = {USA},
volume = {241},
number = {C},
issn = {0164-1212},
url = {https://doi.org/10.1016/j.jss.2026.112983},
doi = {10.1016/j.jss.2026.112983},
journal = {J. Syst. Softw.},
month = aug,
numpages = {13},
keywords = {Computational notebooks, Jupyter notebooks, Software evolution, Fine-grained logs}
}
```

### Supplementary Materials (Zenodo)

```bibtex
@misc{titov2025supplementary,
  title        = {Observing Fine-Grained Changes in Jupyter Notebooks 
                  During Development Time: Supplementary Materials},
  author       = {Titov, Sergey and Grotov, Konstantin and Sarasua, Cristina 
                  and Golubev, Yaroslav and Ramasamy, Dhivyabharathi 
                  and Bacchelli, Alberto and Bernstein, Abraham 
                  and Bryksin, Timofey},
  year         = {2025},
  doi          = {10.5281/zenodo.16098734},
  howpublished = {Zenodo}
}
```

**Zenodo DOI:** [https://doi.org/10.5281/zenodo.16098734](https://doi.org/10.5281/zenodo.16098734)

---

## 🙏 Acknowledgments

This work was partially supported by the Swiss National Science Foundation through projects:
- **D3** (contract no. CRSII5 205975)
- **CrowdAlytics** (contract no. 200020 184994)

We thank all hackathon participants for their valuable contribution.

---

<p align="center">
  <i>Made by JetBrains Research and University of Zurich</i>
</p>
