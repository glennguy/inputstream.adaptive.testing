#!/bin/bash
KODI_VERSION=$1
mkdir -p $HOME/.deploy/$KODI_VERSION
cd $HOME/.deploy/$KODI_VERSION
for f in $TRAVIS_BUILD_DIR/*.zip; do
  if [[ $f == *"$KODI_VERSION"* ]]; then
    mkdir -p $TRAVIS_BUILD_DIR/.build/$KODI_VERSION/$(basename "$f" .zip)
    unzip $f -d $TRAVIS_BUILD_DIR/.build/$KODI_VERSION/$(basename "$f" .zip)
    python3 $TRAVIS_BUILD_DIR/manage_repo.py $TRAVIS_BUILD_DIR -b $TRAVIS_BUILD_DIR/.build/$KODI_VERSION/$(basename "$f" .zip)/${APP_ID}
  fi
done