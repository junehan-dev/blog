#!/bin/bash
path=content/post/PBl-DST_ALGOR
if [ -z $1 ]
then
	echo "run like ./autopbl leetcode/something"
else
	echo "no arg"
	hugo new ${path}/$1.md
	today=$( cat ${path}/$1.md | grep date )
	cat BASES/PBL_PROGRAM > ${path}/$1.md
	echo ${today} >> ${path}/$1.md
	vim ${path}/$1.md
fi
