#!/bin/bash

find . -type f -size +1M > large_files.txt

cat large_files.txt
