#!/usr/bin/env bash

inp_dir=$1
out_dir=$2

python retriever/format-query.py \
  --dir ${inp_dir} \
  --save_to ${out_dir} \
  --as_torch
