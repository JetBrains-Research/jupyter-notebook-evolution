# Machine Learning Problem
## Description

In this task, you will solve a classification problem. You are given a dataset of notebooks
where each code cell in a notebook is represented by a datapoint. The dataset is
already preprocessed to a certain extent for you.

Each datapoint has several features and is given multiple classification labels.
These labels represent what data science activities they perform.
For example, if a datapoint is given classification labels of `modelling` and
`evaluation`, then the lines of code in that code cell performs modelling and
evaluation activities.

There are a total of ten classes representing ten data science activities. Each code cell
can be assigned to one or more labels, which are indicated using one-hot encoding in
the dataset. Each code cell also has one `primary_label` that represents the main
activity in the cell.

Following are the self-explanatory ten classes available: `load_data`, `helper_functions`,
`data_preprocessing`, `data_exploration`, `modelling`, `prediction`, `evaluation`,
`result_visualization`, `save_results`, `comment_only`.
Size of the dataset: 9678 x 32.

In total, there are 9678 code cells in this dataset.

The features (21) are explained briefly below:
- `filename` – name of the notebook the cell belongs to;
- `cell_type` – type of the cell (_e.g._, markdown, code);
- `cell_number` - the position of the cell in the notebook;
- `execution_count` - the execution order of the cell in the notebook;
- `linesofcomment` – number of lines of comment in the cell;
- `linesofcode` – number of lines of code in the cell;
- `variable_count` – number of variables in the cell;
- `function_count` – number of functions in the cell;
- `text/plain` – content of the output cell (one-hot encoding);
- `image/png` – content of the output cell (one-hot encoding);
- `text/html` – content of the output cell (one-hot encoding);
- `execute_result` - output type of the cell (one-hot encoding);
- `display_data` - output type of the cell (one-hot encoding);
- `stream` - output type of the cell (one-hot encoding);
- `error` - output type of the cell (one-hot encoding);
- `text` - content of the cell (_e.g._, code or text depending on the cell type);
- `comment` - comments (in code cells only);
- `code_line_before` – last line of code in the previous code cell;
- `code_line_after` – first line of code in the next code cell;
- `markdown_heading` – first line of the preceding markdown cell;
- `packages_info` – `man` page information about the libraries imported in the cell.

Classification labels include 10 one-hot encodings of 10 classes + 1 `primary_label`.

## Evaluation
Your task is to create a classification algorithm that will predict the `primary_label` for 
each data point. We will use the F1 Measure to compare the models. Please ensure
that your notebook has all the necessary code for reading the data, training the model,
calculating the metric, and outputting it with the necessary commentary.