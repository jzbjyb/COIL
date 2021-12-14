#!/usr/bin/env bash

pip install transformers==4.2.1
pip install datasets==1.1.3

conda install pytorch==1.8.1 cudatoolkit=10.2 -c pytorch -c conda-forge
pip install faiss-cpu==1.7.0
pip install torch-scatter==2.0.6 -f https://data.pyg.org/whl/torch-1.8.1+cu102.html
pip install spacy==3.2.1

pushd retriever/retriever_ext
pip install Cython
python setup.py build_ext --inplace
popd
