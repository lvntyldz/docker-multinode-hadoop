#!/usr/bin/env bash

hadoop fs -rm -r /demo

hadoop fs -mkdir -p /demo/input

hadoop fs -copyFromLocal /tmp/sancar.txt /demo/input/

hadoop jar /tmp/codeSamples.jar com.wc.WordCount /demo/input /demo/output

hadoop fs -cat /demo/output/part-r-00000


