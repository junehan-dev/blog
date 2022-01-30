#!/bin/bash

hugo -D -t hugo-tranquilpeak-theme
cd public
git add .
msg="rebuilding site `date`"
if [ $# -eq 1 ]
	then msg="$1"
fi
git commit -m "$msg"
git push origin main
cd ..
git add .
git commit -m "$msg"
git push origin main
