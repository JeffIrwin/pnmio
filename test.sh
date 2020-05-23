#!/bin/bash

inputs=tests/*.txt

frames=( 1 2 4 5 )

exebase=pnmio
outdir=./tests/
expectedoutdir=./tests/expected-output
outputext=p*m
use_stdin="false"
use_pushpop="false"

#===============================================================================

source ./submodules/bat/test.sh

