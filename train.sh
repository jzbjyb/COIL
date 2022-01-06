#!/usr/bin/env bash

model=allenai/scibert_scivocab_uncased  # bert-base-uncased
input=$1
output=$2
port=$3
args="${@:4}"
ngpu=4
batch_size=64
epoch=30

python -m torch.distributed.launch --nproc_per_node=${ngpu} --master_port ${port} run_marco.py \
  --output_dir ${output} \
  --model_name_or_path ${model} \
  --do_train \
  --save_steps 4000 \
  --train_dir ${input} \
  --q_max_len 128 \
  --p_max_len 128 \
  --fp16 \
  --per_device_train_batch_size ${batch_size} \
  --train_group_size 2 \
  --cls_dim 768 \
  --token_dim 32 \
  --warmup_ratio 0.1 \
  --learning_rate 5e-6 \
  --num_train_epochs ${epoch} \
  --overwrite_output_dir \
  --dataloader_num_workers 16 \
  --no_sep \
  --pooling max \
  ${args}
