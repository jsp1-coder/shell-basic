#!/bin/bash

# jspark
# 2020.11.30.

# 데이터 위치 및 저장 변수
cur_dir=$PWD
data_dir=$cur_dir/train_folder
save_dir=$cur_dir/checked_folder

# $save_dir 이 이미 있는지 확인. 이번에는 유저한테 먼저 물어보기.
if [ -d $save_dir ]; then
    echo "$save_dir 가(이) 발견되었습니다. 현재 폴더를 지우고 새롭게 생성할까요?"
    
    # while loop을 사용하는 이유는, 유저에게 답변을 받아야 되는데 이 답변이 부정확할 경우 계속해서 뭃어봐야 하기 때문.
    # while loop을 순회하다가 특정 조건에서 종료하려면 if문과 break문을 사용할 수 있다.
    while true; do
        # 유저가 입력한 답변을 user_yn 변수에 담기.
        read -p "y(es)/n(o)" user_yn
        user_yn=`echo $user_yn | tr '[:upper:]' '[:lower:]'`
        
        # || 와 같은 논리연산자를 사용할 때는 [[]] 대괄호를 두 개 써줘야 함.
        if [[ $user_yn == 'y' || $user_yn == 'yes' ]]; then
            echo "기존 $save_dir 를(을) 삭제하고 새롭게 생성합니다."
            rm -r $save_dir
            mkdir $save_dir
            break
            elif [[ $user_yn == 'n' || $user_yn == 'no' ]]; then
            echo "기존 $save_dir 를(을) 삭제하지 않고 코드를 종료합니다."
            exit 1
        else
            echo "입력하신 값이 잘못되었습니다."
        fi
    done
else
    mkdir $save_dir
fi  # 첫 번째 점검사항 종료

# data 디렉토리 확인.
if [ ! -d $data_dir ]; then
    echo "$data_dir 가(이) 없습니다. 데이터 폴더를 현재 위치로 옮겨주세요."
    echo "YOUR CURRENT DIRECTORY : $PWD"
    exit 1
fi

# data_dir 내의 폴더 탐색하기.
echo "작업을 실행합니다." `date`
for txt_dir in `ls $data_dir`; do
    # 디렉토리가 맞으면 진행할 것.
    if [ -d $data_dir/$txt_dir ]; then
        # txt 파일에 대한 검토도 진행되어야 하므로, txt를 기준으로 탐색한다.
        for txt_file in `ls $data_dir/$txt_dir | grep txt`; do
            # txt 파일이 안 비었을 경우 찾기.
            # -z 빈 값에 true를 주는 옵션
            if [[ ! -z `grep "[가-힣a-zA-Z0-9]" $data_dir/$txt_dir/$txt_file` ]]; then
                wav_file=`echo $txt_file | sed 's/txt/wav/g'`
                #txt 파일의 쌍이 되는 오디오 파일이 있는지 확인한다.
                if [ -f $data_dir/$txt_dir/$wav_file ]; then
                    # txt가 안 비었고, 오디오 파일도 존재하니 save_dir로 이동한다.
                    cp $data_dir/$txt_dir/{$wav_file,$txt_file} $save_dir
                fi
            fi
        done
    fi
done


