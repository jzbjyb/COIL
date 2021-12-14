#!/usr/bin/env bash

model_dir=$1
tokenizer=$2
inp_dir=$3
out_dir=$4
args="${@:5}"

mkdir -p ${out_dir}
python run_marco.py \
  --output_dir ${out_dir} \
  --model_name_or_path ${model_dir} \
  --tokenizer_name ${tokenizer} \
  --cls_dim 768 \
  --token_dim 32 \
  --do_encode \
  --no_sep \
  --p_max_len 16 \
  --pooling max \
  --fp16 \
  --per_device_eval_batch_size 128 \
  --dataloader_num_workers 12 \
  --encode_in_path ${inp_dir} \
  --encoded_save_path ${out_dir} \
  ${args}
