#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo "CURRENT_DIR : $CURRENT_DIR"

RUN_DIRECTORY="$(dirname "$CURRENT_DIR")"
#echo "RUN_DIRECTORY : $RUN_DIRECTORY"

SRC_DIRECTORY="$(dirname "$RUN_DIRECTORY")"
#echo "SRC_DIRECTORY : $SRC_DIRECTORY"

ROOT_DIRECTORY="$(dirname "$SRC_DIRECTORY")"
echo "ROOT_DIRECTORY : $ROOT_DIRECTORY"


#compile with maven
mvn clean install -Dtest.skip=true


#copy compiled jar file to master container
docker cp $ROOT_DIRECTORY/target/codeSamples-1.0-SNAPSHOT.jar  master:/tmp/codeSamples.jar
docker cp $CURRENT_DIR/sancar.txt  master:/tmp/sancar.txt
docker cp $CURRENT_DIR/hadoop.sh  master:/tmp/hadoop.sh


docker exec -it master bash -c  "/tmp/hadoop.sh"

