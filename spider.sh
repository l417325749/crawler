#!/bin/bash
# demo: sh spider.sh url referer output

url=$1
referer=$2
output=$3

if [ ! $url ]; then
  echo "url不能为空"
  exit 1
fi

if [ ! $referer ]; then
  echo "referer不能为空"
  exit 1
fi

if [ ! $output ]; then
  echo "output不能为空"
  exit 1
fi

fileName="${url##*/}"
urlPath="${url%/*}"

#文件名
if [ -z $fileName ]; then
  echo "文件名不能为空"
  exit 1
fi

#定义临时目录
#tmp_dir="./$(tr -dc "0-9a-z" </dev/urandom | head -c 10)"
tmp_dir="./$RANDOM"
if [ -d $tmp_dir ]; then
  echo "目录已存在\n"
  exit 1
else
  mkdir $tmp_dir
fi

#循环下载视频片段,存入临时文件夹中
for line in $(curl -e $referer $urlPath/$fileName | grep .ts); do
  wget --referer $referer $urlPath/$line -P $tmp_dir
done

#合成视频,需支持ffmpeg
cat $tmp_dir/*.ts | ffmpeg -i pipe: -c:a copy -c:v copy $output

#删除临时目录
# rm -rf $tmp_dir

#返回文件的绝对路径
echo "$(pwd)/$output"

exit 0

