#!/usr/bin/env bash

model_dir=$1
tokenizer=$2
inp_dir=$3
out_dir=$4

total_split=40
num_gpu=8
gpu_id=0

for i in $(seq -f "%02g" 0 $((${total_split} - 1)))  # default to 8 pieces
do
  mkdir -p ${out_dir}/split${i}
  CUDA_VISIBLE_DEVICES=${gpu_id} python run_marco.py \
    --output_dir ${out_dir} \
    --model_name_or_path ${model_dir} \
    --tokenizer_name ${tokenizer} \
    --cls_dim 768 \
    --token_dim 32 \
    --do_encode \
    --no_sep \
    --p_max_len 128 \
    --pooling max \
    --fp16 \
    --per_device_eval_batch_size 128 \
    --dataloader_num_workers 4 \
    --encode_in_path ${inp_dir}/split${i} \
    --encoded_save_path ${out_dir}/split${i} \
    --compress_ratio 8 \
    --use_raw_repr &
  gpu_id="$((gpu_id + 1))"
  if (( ${gpu_id} == ${num_gpu} )); then
    wait
    gpu_id=0
  fi
done
wait
