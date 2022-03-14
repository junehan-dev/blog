#!/bin/bash
path=content/post/STUDY-THEORIES
if [ -z $1 ]
then
	echo "run like ./autopbl algorithm/stack"
else
	echo "no arg"
	hugo new ${path}/$1.md
	today=$( cat ${path}/$1.md | grep date )
	title=$( cat ${path}/$1.md | grep title )
	cat BASES/STUDY > ${path}/$1.md
	echo ${title} >> ${path}/$1.md
	echo ${today} >> ${path}/$1.md
	vim ${path}/$1.md
fi
