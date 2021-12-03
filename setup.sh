#!/usr/bin/env bash

pip install transformers==4.2.1
pip install datasets==1.1.3

conda install pytorch==1.8.1 cudatoolkit=11.1 -c pytorch -c conda-forge
pip install faiss-cpu==1.7.0
pip install torch-scatter==2.0.6 -f https://data.pyg.org/whl/torch-1.8.1+cu111.html

pushd retriver/retriever_ext
pip install Cython
python setup.py build_ext --inplace
popd
