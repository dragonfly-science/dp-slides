#! /bin/bash

set -ex

make slides

cp differential-privacy.html /publish/index.html
cp notebooks/*.html /output
