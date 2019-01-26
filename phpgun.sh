#!/bin/bash
help_head=$'Параметры:\0'
help_end=$'\0'
help=$'  -h \t\t\t Help - Показать справку\0'

use_head=$'Использование:'
use_end=$'\0'
use=$'  ./phpgun.sh -f [ФАЙЛЫ] -p [PHP-скрипт] -c [количество]\0'

silent=$'  -s \t\t\t Выполнить скрипт в silent-режиме (тихий режим, без вывода сообщений)'
silent_mode=false

fileDir_help=$'  -f "./files/*" \t Укажите файлы, которые необходимо передать php-скрипту\0'
phpScript_help=$'  -p "./script.php" \t Укажите скрипт php\0'
scriptNumber_help=$'  -c 1000 \t\t Укажите количество одновременно запущенных php-скриптов\0'

while [ -n "$1" ]
do
	case "$1" in
		-f) param="$2"
			fileDir=$param
		shift ;;
		-p) param="$2"
			phpScript=$param
		shift ;;
		-c) param="$2"
			scriptNumber=$param
		shift ;;
		-s) silent_mode=true;;
		-h) echo "$use_head"; echo "$use"; echo "$use_end"
			echo "$help_head"; echo "$help";
			echo "$silent"
			echo "$fileDir_help"; echo "$phpScript_help"; echo "$scriptNumber_help"
			echo "$help_end"
			exit;;
		--) shift
		break ;;
		*) echo "$1 is not an option";;
	esac
	shift
done


# echo $fileDir
# echo $phpScript
# echo $scriptNumber
# fileDir="./test/*.log"
# phpScript="./script.php"
# scriptNumber=10
if [[ -z $fileDir || -z $phpScript || -z $scriptNumber ]]
then
	echo "$use_head"; echo "$use"; echo "$use_end"
	echo "$help_head";	echo "$help"

	if [[ -z $fileDir ]]; then
		echo "$fileDir_help"
	fi

	if [[ -z $phpScript ]]; then
		echo "$phpScript_help"
	fi

	if [[ -z $scriptNumber ]]; then
		echo "$scriptNumber_help"
	fi

	echo "$help_end"
	exit
fi

for ((i=0; i<scriptNumber; i++))
do
	currentArray[$i]="";
done

n=0;
# for fileDir in "$@"
for file in ${fileDir}
do
	if [ -f $file ]; then
		fileArray[n++]=$file;
	fi
done
fileArray_size=${#fileArray[*]}


fileArray_index=0;

if [ "$silent_mode" != true ]; then
	echo $'== phpgun = Количество файлов: '$fileArray_size $' \t ==================='

	if [ $fileArray_size -le 0 ]; then
		echo $'== phpgun = Нет файлов - выход \t\t ==================='
		exit
	fi
fi




# echo "currentArray size: ${#currentArray[*]}"

while [ $fileArray_size -gt $fileArray_index ]
do
	for index in ${!currentArray[*]}
	do
		if [[ -n ${currentArray[index]} && -f ${currentArray[index]} ]] ; then
			# echo "Файл ${currentArray[index]} - существует"
			continue
		else
			# echo "Файл ${currentArray[index]} - не существует"
			currentArray[$index]=${fileArray[$fileArray_index]}
			php ${phpScript} ${fileArray[$fileArray_index]} &
			((fileArray_index++))
			if [ $fileArray_size -le $fileArray_index ]
			then
				# sleep 1
				if [ "$silent_mode" != true ]; then
					echo $'== phpgun = Все файлы переданы скрипту \t ==================='
				fi
				break
			fi
		fi
	done
	# exit
done

# for ((index=0; index < ${fileArray_size}; index++))
allfile=1
while ((allfile))
do
	allfile=0
	for index in ${!fileArray[*]}
	do
		if [[ -n ${fileArray[index]} && -f ${fileArray[index]} ]] ; then
			allfile=1
		fi
	done
done

if [ "$silent_mode" != true ]; then
	echo $'== phpgun = Все файлы удалены \t\t ==================='
fi