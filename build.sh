#! /bin/bash

set -ex

make slides

cp differential-privacy.html /publish
cp notebooks/*.html /output
