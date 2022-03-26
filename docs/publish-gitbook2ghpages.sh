#!/bin/bash -e

rm -rf docs
gitbook build . docs

mv docs/.gitbook/assets docs/assets
rm -rf docs/.gitbook

find docs/ -iname "*.html" | xargs sed -i 's/.gitbook\/assets/assets/g'
find docs/ -iname "*.html" | xargs sed -i 's/\\_/_/g'

git add docs
git cc -m 'publish book'

git push
