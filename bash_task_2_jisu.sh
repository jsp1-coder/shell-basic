#!/bin/bash

# 데이터 위치 및 저장 변수.

# 대표적인 환경변수..
# PWD : 현재 디렉토리의 절대 경로명
# PATH : 명령어 검색 경로
# HOME : 사용자 홈 디렉토리
# SHELL : 로그인 쉘의 절대 경로명
# USER : 사용자 이름
# 터미널에 $환경변수 와 같이 입력하면 현재 환경변수 값을 알 수 있다.
cur_dir=$PWD
data_dir=$cur_dir/train
save_name=$cur_dir/saved.txt

# delimiter 변수.
# 우리는 tab을 delimiter로 쓰기로 했으니까 tab을 의미하는 \t 를 적는다.
delim='\t'

# 점검사항 (if문으로 확인하기)
# 이미 저장된 saved.txt가 있는지 확인
# 정보를 저장하고자 하는 train 폴더가 존재하는지 확인.

# save file 생성 유무 체크

# -f는 뒤의 변수명이 파일인지 체크하는 옵션
# if문 작성 시에 [] 대괄호 한칸 띄어쓰기 해야 하는 구나.
# if [ -f $save_name ] 처럼 대괄호를 띄어서 써야 하는 구나.
if [ -f $save_name ]; then
    echo "$save_name 가(이) 발견되었습니다. 현재 파일을 지우고 새롭게 생성합니다."
    rm $save_name  # 이미 존재하는 경우 삭제해버리기
fi
touch $save_name  # touch는 원하는 이름으로 빈 파일을 생성하는 명령어.

# 데이터 디렉토리 확인
# 우리가 데이터를 추출하고자 하는 트레인 폴더가 없다면 더이상 작업을 진행하는 게 무의미하기 때문에 먼저 체크하는 것이다.
# data_dir 가 없는지 먼저 확인
# -d는 변수명이 디렉토리인지 체크하는 옵션
if [ ! -d $data_dir ]; then
    echo "$data_dir 가(이) 없습니다. 데이터 폴더를 현재 위치로 옮겨주세요."
    echo "YOUR CURRENT DIRECTORY : $PWD"
    exit 1  # exit 명령어로 코드 종료
fi

# wav 디렉토리 이동하면서 wav 및 txt 탐색하기.
# 진행하려는 사항과 날짜 및 시간을 echo로 출력
# `date` 작업을 시작한 날짜 및 시간을 기록할 수 있다.
echo "$save_name 파일 생성하기." `date`
for wav_dir in `ls $data_dir`; do
    # directory가 맞을 때 작업을 진행하라.. 변수명에 담긴게 디렉토리 이름이 맞는지.
    if [ -d $data_dir/$wav_dir ]; then
        echo "현재 작업 진행 폴더 : $wav_dir"
        
        # 웨이브 데이터의 절대 경로와 그 페어가 되는 텍스트 데이터만 저장하면 된다.
        # 따라서 텍스트 파일만 수집해서 위 2가지 정보를 다 얻도록 하자.
        # wav_dir 내에 있는 txt 파일만 가져오자.
        # ls 명령어로 모든 파일을 가져온 뒤 파이프라인(|)으로 정보들을 넘겨주고, grep 명령어로 txt가 들어간 파일들을 추출하여 each 변수명으로 순차적으로 넘겨준다.
        for each in `ls $data_dir/$wav_dir | grep txt`; do
            txt_sent=`cat $data_dir/$wav_dir/$each`
            wav_name=`echo $each | sed 's/txt/wav/g'` # 파일명이 같으므로 txt를 wav로 치환하기.  's/기존단어/치환단어/g'
            wav_full_path="$data_dir/$wav_dir/$wav_name"
            
            # echo -e 옵션 : \t 를 단순 글자가 아닌 tab으로 읽게 해준다.
            # echo로 출력한 문장을 >> 이어쓰기로 파일에 넣어준다. >는 덮어쓰기.
            echo -e "$wav_full_path$delim$txt_sent" >> $save_name;
        done
    fi;
done

echo "완료." `date`