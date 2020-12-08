#!/bin/bash

# 오디오 데이터
audio_dir=C:/Users/박지수학부재학불어불문학과/Documents/Dev/SHELL_Basic/1강/train

#전체 오디오 시간 기록
total_time=0

# 현재 폴더 내 폴더들을 순차적으로 탐색하기 위해 for loop 사용.
# bash에서 위에 선언된 변수를 사용할 때는 변수이름 앞에 꼭 $ 를 붙여야 한다.
# 오디오 데이터 내 모든 폴더 검색하기
# ls 는 폴더 명 내에 담긴 모든 파일들을 표시해주는 명령어이다.
# 이를 back tick 안에 넣음으로써 ls 명령어의 결과물을 for loop 내에 순차적으로 넣게 된다.
# 즉 train 디렉토리 내의 fv01과 fv02가 순차적으로 sub_dir 에 할당
# 백틱은 `` 내에 명령어를 실행하고 그 값을 어딘가에 줄 때 사용
for sub_dir in `ls $audio_dir`; do
    echo "$sub_dir 폴더에 대해서 오디오 시간을 계산합니다."
    # 각 폴더 내 음성자료 검색하기
    
    # $audio_dir/$sub_dir 내에 있는 모든 파일들을 ls 명령어로 검색하고
    # | (파이프) 를 이용해서 이 결과물을 다음 명령어로 넘겨주기.
    # | (파이프) 는 이전에 있던 결과물을 그 다음으로 넘겨주는 역할을 한다.
    # 이렇게 전달된 파일 리스트 중에 .wav 파일만 선별하기 위해서 grep이라는 명령어를 쓴다.
    # 백틱 안에 써서 명령어를 실행한 결과 값을
    for audio_file in `ls $audio_dir/$sub_dir | grep wav` ; do
        
        # soxi 명령어 사용.
        # -D 옵션은 시간만 가져오겠다는 옵션으로 이를 통해 불필요한 정보를 제거함.
        each_time=`soxi -D $audio_dir/$sub_dir/$audio_file`
        
        # 이렇게 새로 담긴 each_time 변수 값을 계속 total_time 에 더해줌.
        # 전체 오디오 시간 데이터 업데이트
        # 소수점 이하의 값을 연산할 때는 bc 명령어를 사용
        total_time=`echo $total_time + $each_time | bc`
    done
done
echo "$audio_dir 폴더 내 모든 오디오 총 시간은 $total_time 초 입니다."
