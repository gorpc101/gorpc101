#!/bin/bash -e

rm -rf docs

USE_DOCKER=0
# Parse command line options
while getopts "dh" opt; do
    case "$opt" in
    d)  # use docker container to build
        USE_DOCKER=1
        echo "docker flag set"
        ;;
    h)  # Display help
        echo "Usage: ./publish-gitbook2ghpages.sh [-d] [-h]"
        echo "-d: use docker container hitzhangjie/gitbook-cli to build pages"
        echo "    otherwise, use native gitbook to build pages"
        echo "-h: show the help message"
        exit 0
        ;;
    *)  # Invalid option
        echo "Error: Invalid option $opt"
        exit 1
        ;;
    esac
done

if [ $USE_DOCKER -eq 1 ]
then
    docker run --rm -v $(pwd -P):/root/gitbook hitzhangjie/gitbook-cli:latest gitbook build . docs
else
    gitbook build . docs
fi

mv docs/.gitbook/assets docs/assets
rm -rf docs/.gitbook

find docs/ -iname "*.html" | xargs sed -i 's/.gitbook\/assets/assets/g'
find docs/ -iname "*.html" | xargs sed -i 's/\\_/_/g'
find docs/ -iname "*.html" | xargs sed -i 's/\/_/_/g'

git add docs
git cc -m 'publish book'

git push
