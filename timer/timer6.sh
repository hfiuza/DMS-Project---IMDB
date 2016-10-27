#!/bin/bash

rm q6.out

START=$(date +%s.%N)
psql postgres -f ../queries/q6.sql > ../queries/q6.out
END=$(date +%s.%N)
DIFF=$(echo "$END - $START" | bc)
echo $DIFF

