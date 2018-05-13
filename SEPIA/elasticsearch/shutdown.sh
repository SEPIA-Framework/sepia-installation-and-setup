#!/bin/bash
echo "Shutting down Elasticsearch"
cd bin
PIDFile="elasticPID.pid"
CurPID=$(<"$PIDFile")
kill -SIGTERM $CurPID
