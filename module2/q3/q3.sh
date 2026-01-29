#!/bin/bash

grep "ERROR" log.txt | grep -v "DEBUG" > filtered_log.txt

cat filtered_log.txt
