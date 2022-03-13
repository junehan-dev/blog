#!/bin/bash
diary_path=content/post/DIARY
today=0
if [ -z $1 ]
then
	today=$( date -I )
else
	today=$1
	echo "no arg"
fi
hugo new ${diary_path}/${today}.md
date=$( cat ${diary_path}/${today}.md | grep date )
cat BASES/DIARY > ${diary_path}/${today}.md
echo ${date} >> ${diary_path}/${today}.md
vim ${diary_path}/${today}.md
