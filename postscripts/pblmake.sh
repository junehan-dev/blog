#!/bin/bash
path=../content/post/PBL-DST_ALGOR
if [ -z $1 ]
then
	echo "run like ./autopbl leetcode/something"
else
	echo "no arg"
	hugo new ${path}/$1.md
	today=$( cat ${path}/$1.md | grep date )
	title=$( cat ${path}/$1.md | grep title )
	cat ../BASES/PBL_PROGRAM >> ${path}/$1.md
	vim ${path}/$1.md
fi
