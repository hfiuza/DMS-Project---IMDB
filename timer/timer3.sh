#!/bin/bash

rm q3.out

START=$(date +%s.%N)
psql postgres -f ../queries/q3.sql > ../queries/q3.out
END=$(date +%s.%N)
DIFF=$(echo "$END - $START" | bc)
echo $DIFF

