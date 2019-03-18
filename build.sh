#! /bin/bash
set -ex

export RUN=

make slides

cp differential-privacy.html /publish/index.html
cp notebooks/*.html /output
