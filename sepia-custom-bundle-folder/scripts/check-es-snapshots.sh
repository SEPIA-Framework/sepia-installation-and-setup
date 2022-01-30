#!/bin/bash
echo ""
echo "This script will show your snapshots ... if you've created any."
echo ""
curl -X GET "http://localhost:20724/_snapshot/_all?pretty=true"
echo ""
curl -X GET "http://localhost:20724/_snapshot/sepia-backups/_all?pretty=true"
echo ""