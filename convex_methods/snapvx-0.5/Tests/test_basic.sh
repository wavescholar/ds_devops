#!/bin/bash

for dir in tests_installation tests_functionality unit_tests;
do
    cd $dir
    python -m unittest discover -v
    cd ..
done
