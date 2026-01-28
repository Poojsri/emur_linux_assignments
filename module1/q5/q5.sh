#!/bin/bash

mkdir dir1
cd dir1

touch file1
sleep 1
touch file2
sleep 1
touch file3

ls -lt > sorted_files.txt

cat sorted_files.txt
