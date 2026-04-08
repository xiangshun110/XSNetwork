#!/bin/sh

# 1. 先检查 Ruby 语法
ruby -c XSNetwork.podspec


echo "输入tag:"
read tag

# tag=$1

if [[ -n $tag ]];then
    echo "当前tag: ${tag} "
else
    echo "请输入tag"
    exit;
fi


git add --all
git commit -m "build:${tag}"
git push github master

git tag $tag
git push github --tags

# 2. 再 lint
pod spec lint XSNetwork.podspec --use-libraries --verbose

pod trunk push XSNetwork.podspec --allow-warnings --verbose --use-libraries --skip-import-validation
# pod repo push master XSNetwork.podspec --allow-warnings