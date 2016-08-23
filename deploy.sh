#!/bin/bash

set -o errexit -o nounset
if [ "$TRAVIS_BRANCH" != "master" ]
then
  echo "This commit was made against the $TRAVIS_BRANCH and not the master! No deploy!"
  exit 0
fi

rev=$(git rev-parse --short HEAD)

cd _book

git init
git config user.name "8427003"
git config user.email "8427003@qq.com"

git remote add upstream "https://$GH_TOKEN@github.com/lijun401338/lijun401338.github.io.git"
git fetch upstream
git reset upstream/master

echo "www.css3.io" > CNAME


git add -A
git commit -m "rebuild pages at ${rev}"
git push -q upstream HEAD:master
