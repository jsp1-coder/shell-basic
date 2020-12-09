#!/bin/bash


cur_dir=$PWD
data_dir=$cur_dir/train

# 이렇게 변수를 만들었으면 변수명을 그대로 쓸 것.
save_folder=$cur_dir/single_utterance_folder

echo "$cur_dir에 폴더를 생성합니다." `date`
mkdir single_utterance_folder
for wav_dir in `ls $data_dir`; do
    if [ -d $data_dir/$wav_dir ]; then
        echo "현재 작업 진행 폴더 : $wav_dir"
        
        for each in `ls $data_dir/$wav_dir | grep txt`; do
            file_name=`basename $each .txt`
            mkdir single_utterance_folder/"$file_name"
            mv $data_dir/$wav_dir/"$each" single_utterance_folder/"$file_name"
        done
        for each in `ls $data_dir/$wav_dir | grep wav`; do
            file_name=`basename $each .wav`
            mv $data_dir/$wav_dir/"$each" single_utterance_folder/"$file_name"
        done
    fi;
done

echo "완료." `date`