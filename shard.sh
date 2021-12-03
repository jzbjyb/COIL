#!/usr/bin/env bash

inp_dir=$1
out_dir=$2

total_split=40
group=8
id=0

for i in $(seq 0 $((${total_split} - 1)))
do
  python retriever/sharding.py \
    --n_shards ${total_split} \
    --shard_id $i \
    --dir ${inp_dir} \
    --save_to ${out_dir} \
    --use_torch &
  id="$((id + 1))"
  if (( ${id} == ${group} )); then
    wait
    id=0
  fi
done
wait
