#!/usr/bin/env bash

set -e

set -x

cd ..
git clone -b beta https://github.com/flutter/flutter.git
export PATH=`pwd`/flutter/bin:$PATH

flatter channel stable
flutter doctor

echo "Instaled flutter `pwd`/flutter"

flutter build ios --release --no-sound-null-safety --no-codesign
