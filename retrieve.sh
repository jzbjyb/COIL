#!/usr/bin/env bash

qry_dir=$1
doc_dir=$2
out_dir=$3

total_split=40
group=8
id=0

mkdir -p ${out_dir}/intermediate
for i in $(seq -f "%02g" 0 $((${total_split} - 1)))
do
  CUDA_VISIBLE_DEVICES=${i} python retriever/retriever-fast.py \
    --query ${qry_dir} \
    --doc_shard ${doc_dir}/shard_${i} \
    --top 1000 \
    --batch_size 512 \
    --only_invert \
    --save_to ${out_dir}/intermediate/shard_${i}.pt &
  id="$((id + 1))"
  if (( ${id} == ${group} )); then
    wait
    id=0
  fi
done
wait
