#!/bin/bash

COMMIT_MSG_FILE=$1
COMMIT_SOURCE=$2
SHA1=$3

conform enforce --commit-msg-file $COMMIT_MSG_FILE
