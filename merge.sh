#!/usr/bin/env bash

score_dir=$1
qry_dir=$2

python retriever/merger.py \
  --score_dir ${score_dir}/intermediate/ \
  --query_lookup  ${qry_dir}/cls_ex_ids.pt \
  --depth 1000 \
  --save_ranking_to ${score_dir}/rank.txt
