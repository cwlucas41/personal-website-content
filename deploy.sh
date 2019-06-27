#!/bin/sh
aws s3 cp . s3://chriswlucas.com-origin/ --recursive --exclude ".*" --exclude "deploy.sh"
