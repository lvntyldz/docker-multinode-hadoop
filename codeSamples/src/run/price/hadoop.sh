#!/usr/bin/env bash

hadoop fs -rm -r /demo

hadoop fs -mkdir -p /demo/input

hadoop fs -copyFromLocal /tmp/price.txt /demo/input/

hadoop jar /tmp/codeSamples.jar com.price.MaxPrice /demo/input /demo/output

hadoop fs -cat /demo/output/part-r-00000
