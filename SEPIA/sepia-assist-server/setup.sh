#!/bin/bash
JAR_NAME=$(ls | grep "^sepia-assist.*jar" | tail -n 1)
java -jar $JAR_NAME setup --my
