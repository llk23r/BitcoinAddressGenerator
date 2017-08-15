#!/bin/bash
source ./btemp.sh
keyin=$(echo -n $1)
encodeBase58 $keyin	