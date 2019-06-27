#!/bin/sh
aws s3 cp . s3://chriswlucas.com-origin/ --recursive --exclude ".*" --exclude "deploy.sh"
aws cloudfront create-invalidation --distribution-id E3L2VRGKVCQNT0 --paths '/*'
