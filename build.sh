#!/bin/sh
#
set -e

branch=$(git branch --show-current)
podspec_version=$(sed -n "s/.*s.version[[:space:]]*=[[:space:]]*['\"]\\([^'\"]*\\)['\"].*/\\1/p" XSNetwork.podspec | head -n 1)

if [ -z "$branch" ]; then
    echo "未读取到当前分支"
    exit 1
fi

echo "当前分支: ${branch}"
echo "输入tag(默认: ${branch}):"
read tag

tag=${tag:-$branch}

if [ -n "$tag" ]; then
    echo "当前tag: ${tag}"
else
    echo "请输入tag"
    exit 1
fi

if [ -z "$podspec_version" ]; then
    echo "未读取到 XSNetwork.podspec 中的 s.version"
    exit 1
fi

if [ "$podspec_version" != "$tag" ]; then
    echo "XSNetwork.podspec 中的 s.version 为 ${podspec_version}，与当前tag ${tag} 不一致"
    exit 1
fi

if git show-ref --tags --verify --quiet "refs/tags/${tag}"; then
    echo "本地tag ${tag} 已存在，请更换版本号"
    exit 1
fi

if git ls-remote --exit-code --tags github "refs/tags/${tag}" >/dev/null 2>&1; then
    echo "远程tag ${tag} 已存在，请更换版本号"
    exit 1
fi


git add --all
git commit -m "build:${tag}"
git push github "refs/heads/${branch}:refs/heads/${branch}"

git tag "${tag}"
git push github "refs/tags/${tag}:refs/tags/${tag}"


pod spec lint --verbose XSNetwork.podspec

pod trunk push XSNetwork.podspec --allow-warnings --verbose --use-libraries --skip-import-validation
# pod repo push master XSNetwork.podspec --allow-warnings
