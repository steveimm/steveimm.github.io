#!/bin/bash

YEAR=`date +%Y`
MONTH=`date +%m`
DAY=`date +%d`

read -p "Title: " TITLE

if [ -z "$TITLE" ]; then
  echo "Post title cannot be empty"
  exit 1
fi

read -p "Year ($(date +%Y)): " YEAR
read -p "Month ($(date +%m)): " MONTH
read -p "Day ($(date +%d)): " DAY

if [ -z "$YEAR" ]; then
  YEAR=`date +%Y`
fi

if [ -z "$MONTH" ]; then
  MONTH=`date +%m`
fi

if [ -z "$DAY" ]; then
  DAY=`date +%d`
fi

FILENAME="$YEAR-$MONTH-$DAY-$(echo $TITLE | tr '[:upper:]' '[:lower:]' | tr ' ' '-').md"

touch _posts/$FILENAME

cat >> _posts/$FILENAME << 'EOF'
---
title: <UPDATE FULL TITLE>
categories:
  - Posts
classes:
  - wider-content
tags:
  - <UPDATE TAGS>
---
EOF

echo "File created in _posts/$FILENAME"