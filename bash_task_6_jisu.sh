#!/bin/bash

# jspark
# 2020.12.03

#  주어진 input 갯수 확인해서 3개가 아니면 종료시켜 버리기.
if [ $# -ne 3 ]; then
    # $0은 본 스크립트의 이름값을 담고 있음!
    echo "USAGE : $0 [input1: save_folder] [input2: new_folder] [option]"
    echo "save_folder : The directory you'd like to collect the files from"
    echo "new_folder : The directory you'd like to put the collected files in"
    echo "-c | --collection  (collect all the unpaired files..)"
    exit 1
fi

# 입력값 할당
save_folder=$1
new_folder=$2
option=$3


while (( $# )); do
    case "$3" in
        -h|--help)
            
            echo "USAGE : $0 [input1: save_folder] [input2: new_folder] [options]"
            echo "save_folder : The directory you'd like to collect the files from"
            echo "new_folder : The directory you'd like to put the collected files in"
            echo "-c | --collection  (collect all the unpaired files..)"
            exit 1
        ;;
        -c|--collection)
            
            # $new_folder 의 존재 유무 확인하고 작업하기.
            echo "Running the code..." `date`
            if [ -d $save_folder/$new_folder ]; then
                echo "$new_folder already exists. Would you like to delete it and create a new one?"
                
                # 원하는 답변(yes/no)이 올 때 까지 재차 물어봐야 하기 때문에 while loop
                while true; do
                    read -p "y(es)/n(o) : " user_yn
                    user_yn=`echo $user_yn | tr '[:upper:]' '[:lower:]'`
                    if [[ $user_yn == 'y' || $user_yn == 'yes' ]]; then
                        echo "The existing $new_folder will be deleted. Creating a new directory..."
                        rm -r $save_folder/$new_folder
                        mkdir $save_folder/$new_folder
                        break
                        elif [[ $user_yn == 'n' || $user_yn == 'no' ]]; then
                        echo "The existing $new_folder won't be deleted. Exiting.."
                        exit 1
                    else
                        echo "Error : Unvalid input"
                    fi
                done
            else
                mkdir $save_folder/$new_folder
            fi
            
            echo "Collecting .txt files.. Current directory: $save_folder"
            # txt 파일에 대한 검토가 진행되어야 하므로, txt를 기준으로 탐색한다.
            for txt_file in `ls $save_folder | grep txt`; do
                mv $save_folder/$txt_file $save_folder/$new_folder
                
            done
            echo "Collecting .wav files.. Current directory: $save_folder"
            # wav 파일에 대한 검토도 진행되어야 하므로, 이번엔 wav를 기준으로 탐색한다.
            for wav_file in `ls $save_folder | grep wav`; do
                mv $save_folder/$wav_file $save_folder/$new_folder
                
            done
            echo "Completed." `date`
            exit 1
        ;;
    esac
done

