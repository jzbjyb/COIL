#!/usr/bin/env bash

num_split=40
model_short=$1

if [[ ${model_short} == "bert" ]]; then
  model=bert-base-uncased
  tokenizer=bert-base-uncased
  filename=bert.jsonl
  enc_args='--compress_ratio 8 --use_raw_repr'
elif [[ ${model_short} == "scibert" ]]; then
  model=allenai/scibert_scivocab_uncased
  tokenizer=allenai/scibert_scivocab_uncased
  filename=scibert.jsonl
  enc_args='--compress_ratio 8 --use_raw_repr'
elif [[ ${model_short} == "coil" ]]; then
  model=trained_models/hn-checkpoint
  tokenizer=bert-base-uncased
  filename=bert.jsonl
  enc_args='--compress_ratio 8 --use_raw_repr'
elif [[ ${model_short} == "scibert_tok" ]]; then
  model=trained_models/scibert_biology_intro_umls_tok
  tokenizer=allenai/scibert_scivocab_uncased
  filename=scibert.jsonl
  enc_args=""
elif [[ ${model_short} == "scibert_tok_4000" ]]; then
  model=trained_models/scibert_biology_intro_umls_tok/checkpoint-4000
  tokenizer=allenai/scibert_scivocab_uncased
  filename=scibert.jsonl
  enc_args=""
elif [[ ${model_short} == "scibert_tok_12000" ]]; then
  model=trained_models/scibert_biology_intro_umls_tok/checkpoint-12000
  tokenizer=allenai/scibert_scivocab_uncased
  filename=scibert.jsonl
  enc_args=""
elif [[ ${model_short} == "scibert_cls" ]]; then
  model=trained_models/scibert_biology_intro_umls_cls
  tokenizer=allenai/scibert_scivocab_uncased
  filename=scibert.jsonl
  enc_args=""
else
  exit
fi

query_jsonl=/root/exp/adapt_knowledge/data/biolama/umls/prompt_qa.s2orc/test.source.coil/${filename}
doc_jsonl=/root/exp/adapt_knowledge/data/custom_index/biology_intro_umls.coil/${filename}

query_enc=${query_jsonl}.encoded/${model_short}
query_index=${query_enc}.index

doc_split=${doc_jsonl}.split
doc_enc=${doc_split}.encoded/${model_short}
doc_index=${doc_enc}.index

output_dir=data/retrieve/${model_short}

# split doc file into pieces
mkdir -p ${doc_split}
split -l $(( (`wc -l < ${doc_jsonl}`+${num_split})/${num_split} )) ${doc_jsonl} ${doc_split}/split -da 2

# encode
./encode_qry.sh ${model} ${tokenizer} ${query_jsonl} ${query_enc} ${enc_args}
./encode_doc.sh ${model} ${tokenizer} ${doc_split} ${doc_enc} ${enc_args}

# convert format
./format_qry.sh ${query_enc} ${query_index}
./shard.sh ${doc_enc} ${doc_index}

# retrieve
./retrieve.sh ${query_index} ${doc_index} ${output_dir}
./merge.sh ${output_dir} ${query_index}
