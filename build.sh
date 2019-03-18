#! /bin/bash
set -ex

export RUN=

make all

cp differential-privacy.html /publish/index.html
cp notebooks/*.html /output
