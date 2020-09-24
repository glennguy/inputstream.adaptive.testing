#!/bin/bash
while getopts ":k:r:" opt; do
  case $opt in
    k) KODI_VERSION="$OPTARG"
    ;;
    r) REPO="$OPTARG"
    ;;
    \?) echo "Invalid option -$OPTARG" >&2
    ;;
  esac
done

git config --global user.email "travis@travis-ci.org"
git config --global user.name "Travis CI"

mkdir -p $HOME/.deploy/$REPO/$KODI_VERSION
cd $HOME/.deploy/$REPO/$KODI_VERSION
for f in $TRAVIS_BUILD_DIR/*.zip; do
  if [[ $f == *"$KODI_VERSION"* ]]; then
    mkdir -p $TRAVIS_BUILD_DIR/.build/$REPO/$KODI_VERSION/$(basename "$f" .zip)
    unzip $f -d $TRAVIS_BUILD_DIR/.build/$REPO/$KODI_VERSION/$(basename "$f" .zip)
    python3 $TRAVIS_BUILD_DIR/manage_repo.py $TRAVIS_BUILD_DIR -b $TRAVIS_BUILD_DIR/.build/$REPO/$KODI_VERSION/$(basename "$f" .zip)/${APP_ID}
  fi
done

cd $HOME/.deploy/
git config credential.helper "store --file=.git/credentials"
echo "https://${GH_TOKEN}:@github.com" > .git/credentials
git add .
git commit --allow-empty -m "$TRAVIS_COMMIT_MESSAGE"