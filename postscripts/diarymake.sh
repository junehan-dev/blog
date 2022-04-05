#!/bin/bash
basepath=~/Documents/POSTINGS/hugo_blog-Diary_Study 
diary_path=${basepath}/content/post/DIARY
today=$( date -I )
hugo new ${diary_path}/${today}.md
date=$( cat ${diary_path}/${today}.md | grep date )
cat ${basepath}/BASES/DIARY >> ${diary_path}/${today}.md
vim ${diary_path}/${today}.md
