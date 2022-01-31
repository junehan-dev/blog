#!/bin/bash
if [ -z $1 ]
then
	echo "no input"
else
	hugo new post/$1
fi
