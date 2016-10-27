#!/bin/bash

rm q2.out q3.out q6.out q8.out

START=$(date +%s.%N)
psql postgres -f ../queries/q2.sql > ../queries/q2.out
END=$(date +%s.%N)
DIFF=$(echo "$END - $START" | bc)
echo $DIFF

START=$(date +%s.%N)
psql postgres -f ../queries/q3.sql > ../queries/q3.out
END=$(date +%s.%N)
DIFF=$(echo "$END - $START" | bc)
echo $DIFF

START=$(date +%s.%N)
psql postgres -f ../queries/q6.sql > ../queries/q6.out
END=$(date +%s.%N)
DIFF=$(echo "$END - $START" | bc)
echo $DIFF

START=$(date +%s.%N)
psql postgres -f ../queries/q8.sql > ../queries/q8.out
END=$(date +%s.%N)
DIFF=$(echo "$END - $START" | bc)
echo $DIFF
