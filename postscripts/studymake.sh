#!/bin/bash
basepath=~/Documents/POSTINGS/hugo_blog-Diary_Study 
path=${basepath}/content/post/STUDY-THEORIES
if [ -z $1 ]
then
	echo "run like ./autopbl algorithm/stack"
else
	echo "no arg"
	hugo new ${path}/$1.md
	cat ${basepath}/BASES/STUDY >> ${path}/$1.md
	vim ${path}/$1.md
fi
