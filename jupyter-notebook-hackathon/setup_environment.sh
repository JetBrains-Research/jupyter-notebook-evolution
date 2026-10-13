pip install -r requirements.txt
jupyter nbextension install --py mining_extension --user
jupyter nbextension enable --py mining_extension --user

python3 -m jupyter notebook --NotebookApp.default_url="/tree?nbextension=nbextensions_configurator%2Ftree_tab%2Fnbextensions_configurator&amp#nbextensions_configurator"