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

git remote add upstream "https://$GH_TOKEN@github.com/8427003/book.git"
git fetch upstream
git reset upstream/gh-pages

#echo "blog.css3.io" > CNAME

touch .

git add -A .
git commit -m "rebuild pages at ${rev}"
git push -q upstream HEAD:gh-pages
