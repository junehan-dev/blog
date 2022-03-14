#!/bin/bash
diary_path=content/post/DIARY
today=$( date -I )
hugo new ${diary_path}/${today}.md
date=$( cat ${diary_path}/${today}.md | grep date )
cat BASES/DIARY > ${diary_path}/${today}.md
echo ${date} >> ${diary_path}/${today}.md
vim ${diary_path}/${today}.md
