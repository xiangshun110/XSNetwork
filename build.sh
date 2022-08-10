#!/bin/sh
#
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
git push girhub —tasg


pod trunk push XSNetwork.podspec --allow-warnings