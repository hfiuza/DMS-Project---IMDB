#!/bin/bash

rm q2.out

START=$(date +%s.%N)
psql postgres -f ../queries/q2.sql > ../queries/q2.out
END=$(date +%s.%N)
DIFF=$(echo "$END - $START" | bc)
echo $DIFF

