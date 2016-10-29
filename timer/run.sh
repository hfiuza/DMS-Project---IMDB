#!/bin/bash

# usage
if [ -z "$1" -o -z "$2" -o "$1" = "-h" -o "$1" = "help" ]; then 
    echo usage: $0 "query_number {query, explain}" 
    echo ex1: $0 1 query
    echo ex2: $0 2 explain
    exit
fi

# must change these settings for each machine
# -------------------------------------------
PSQL=./psql
QUERY_DIR=../queries
DATABASE=inf553
# mac users (gdate)
# linux users (date)
DATE_CMD=gdate
# -------------------------------------------

# number of iterations to get the average
ITERATIONS=10

# source and output files
QUERY_NUM=$1
QUERY_SRC=q$1.sql
QUERY_OUT=q$1.out
QUERY_EXPLAIN=explain$1.out

# save query or explain output and calculate its execution time
if [ "$2" = explain ]; then
    rm -f $QUERY_DIR/$QUERY_EXPLAIN
    touch tmp.sql
    echo "EXPLAIN " >> tmp.sql
    cat $QUERY_DIR/$QUERY_SRC >> tmp.sql
    $PSQL $DATABASE -f tmp.sql > $QUERY_DIR/$QUERY_EXPLAIN
    rm -f tmp.sql
else
    rm -f $QUERY_DIR/$QUERY_OUT
    SUM=0
    for i in $(seq 1 1 $ITERATIONS)
    do
        START=$($DATE_CMD +%s.%N)
        $PSQL $DATABASE -f $QUERY_DIR/$QUERY_SRC > $QUERY_DIR/$QUERY_OUT
        END=$($DATE_CMD +%s.%N)
        DIFF=$(echo "$END - $START" | bc)
        SUM=$(echo "$SUM + $DIFF" | bc)
        echo "iteration $i: $SUM"
    done
    AVR=$(echo "$SUM/$ITERATIONS" | bc -l)
    echo "average $AVR"
fi


