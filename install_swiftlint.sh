#!/bin/bash

# Copyright 2016 Alex "Alexpls" Plescan

# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
# The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.



# Installs the SwiftLint package.
# Tries to get the precompiled .pkg file from Github, but if that
# fails just recompiles from source.

set -e

SWIFTLINT_PKG_PATH="/tmp/SwiftLint.pkg"
SWIFTLINT_PKG_URL="https://github.com/realm/SwiftLint/releases/download/0.9.1/SwiftLint.pkg"

wget --output-document=$SWIFTLINT_PKG_PATH $SWIFTLINT_PKG_URL

if [ -f $SWIFTLINT_PKG_PATH ]; then
  echo "SwiftLint package exists! Installing it..."
  sudo installer -pkg $SWIFTLINT_PKG_PATH -target /
else
  echo "SwiftLint package doesn't exist. Compiling from source..." &&
  git clone https://github.com/realm/SwiftLint.git /tmp/SwiftLint &&
  cd /tmp/SwiftLint &&
  git submodule update --init --recursive &&
  sudo make install
fi