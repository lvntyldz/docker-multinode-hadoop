#!/usr/bin/env bash

hadoop fs -rm -r /demo

hadoop fs -mkdir -p /demo/input

hadoop fs -copyFromLocal /tmp/French.txt /demo/input/
#hadoop fs -copyFromLocal /tmp/German.txt /demo/input/
hadoop fs -copyFromLocal /tmp/Italian.txt /demo/input/
hadoop fs -copyFromLocal /tmp/Latin.txt /demo/input/
hadoop fs -copyFromLocal /tmp/Portuguese.txt /demo/input/
hadoop fs -copyFromLocal /tmp/Spanish.txt /demo/input/

hadoop jar /tmp/codeSamples.jar com.dictionary.Dictionary /demo/input /demo/output

hadoop fs -cat /demo/output/part-r-00000




