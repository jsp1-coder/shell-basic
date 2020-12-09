#!/bin/bash

# jspark
# 2020.12.01

# 데이터 개수 확인.
# 스크립트 실행 시 인자를 받는 부분. 우리가 받아야 할 인자는 총 두 개 이므로 유저가 입력한 인자가 이보다 적거나 많을 경우 에러를 출력해야 한다.

#  $# 은 인자의 총 갯수, -ne 는 not equal 즉 인자의 총 갯수가 2개가 아니라면..
if [ $# -ne 2 ]; then
    # $0은 본 스크립트의 이름값을 담고 있음!
    echo "사용법 : $0 [입력:data_dir] [출력:save_dir]"
    echo "data_dir : 검사를 진행하고자 하는 폴더."
    echo "save_dir : 검사를 완료 후 결과물을 담는 폴더."
    exit 1
fi

# 인자 갯수에 대한 확인이 끝났음. 이제 인자로 받은 값을 변수명으로 옮겨 담아야 함.
# 배쉬 스크립트에서는 스크립트에 작성된 인자를 $1, $2, $3의 순서대로 저장함.
# 이를 이용해서 원하는 변수명에 담으면 된다.

# 입력값 할당.
# 물론 할당하지 않고 $1 $2로 바로 갖다 쓸 수도 있지만 나중에 코드가 길어지거나 인자값이 많아지면 숫자만으로 뭐가 뭔지 알아보기 힘드므로 할당해주는 게 좋다.

data_dir=$1
save_dir=$2

# data 디렉토리가 있는지 확인.
if [ ! -d $data_dir ]; then
    echo "$data_dir 가(이) 없습니다. 현재 디렉토리에 train_data를 다운받습니다."
    
    # 링크를 이용해서 다운받는 명령어는 wget인데 구글드라이브는 wget로 받을 수 없으므로 다음과 같은 방법을 사용한다.
    file_id=15FfEE8OE_iPHaueNp-KE26Hz27mrP6XC
    file_name=train_folder.zip
    wget -O $file_name 'https://drive.google.com/file/d/'$file_id'/view'
    unzip train_folder.zip
fi

if [ -d $save_dir ]; then
    echo "$save_dir 가(이) 발견되었습니다. 현재 폴더를 지우고 새롭게 생성할까요?"
    
    # 원하는 답변(yes/no)이 올 때 까지 재차 물어봐야 하기 때문에 while loop
    while true; do
        read -p "y(es)/n(o) : " user_yn
        user_yn=`echo $user_yn | tr '[:upper:]' '[:lower:]'`
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
fi


# data_dir 내의 폴더 탐색하기.
echo "작업을 실행합니다." `date`
for txt_dir in `ls $data_dir`; do
    # 디렉토리가 맞으면 진행할 것.
    if [ -d $data_dir/$txt_dir ]; then
        echo "현재 작업 진행 폴더: $txt_dir"
        # txt 파일에 대한 검토도 진행되어야 하므로, txt를 기준으로 탐색한다.
        for txt_file in `ls $data_dir/$txt_dir | grep txt`; do
            # txt 파일이 안 비었을 경우를 찾는다.c
            if [[ ! -z `grep "[가-힣a-zA-Z0-9]" $data_dir/$txt_dir/$txt_file` ]]; then
                #wav_file=`echo $txt_file | sed 's/txt/wav/g'`
                # ${txt_file/txt/wav} 치환?
                wav_file=${txt_file/txt/wav}
                
                #txt 파일의 쌍이 되는 오디오 파일이 있는지 확인한다.
                if [ -f $data_dir/$txt_dir/$wav_file ]; then
                    # txt가 안 비었고, 오디오 파일도 존재하니 save_dir로 이동한다.
                    # {$wav_file,$txt_file}의 의미는?
                    cp $data_dir/$txt_dir/{$wav_file,$txt_file} $save_dir
                fi
            fi
        done
    fi
done
echo "완료." `date`