#!/bin/bash

mkdir -p dir1/dir2
touch dir1/dir2/file.txt

ln -s dir1/dir2/file.txt dir1/file_link.txt

ls -l dir1
