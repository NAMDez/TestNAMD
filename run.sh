#!/bin/bash

file_in=$1
stage=$2
num_cores=$3
num_replicas=$4

echo "$job_name"
if [[ $# < 4 ]]; then
  echo "Usage:"
  echo "1. input.namd"
  echo "2. stage ID"
  echo "3. number of cores"
  echo "4. number of replicas"
  exit
fi

dir_name="/Projects/dhardy/namd/Linux-x86_64-icc-netlrts"

# remove old log files, otherwise new logs will be appended to old ones.
rm -rf log/md${stage}/*
rm -rf output/md${stage}/*

for i in $(seq 1 $num_replicas); do
    let n=$i-1
    mkdir -p "log/md${stage}/${n}"
done

${dir_name}/charmrun ++local +p${num_cores} ${dir_name}/namd2 \
    +replicas ${num_replicas} \
    ${file_in} \
    +stdout log/md${stage}/%d/md${stage}.log
