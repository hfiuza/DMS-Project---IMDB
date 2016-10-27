#!/bin/bash

rm q8.out

START=$(date +%s.%N)
psql postgres -f ../queries/q8.sql > ../queries/q8.out
END=$(date +%s.%N)
DIFF=$(echo "$END - $START" | bc)
echo $DIFF

