#!/bin/bash

thumbsup --config thumbsup.config.json && aws s3 sync ./website s3://jg-production-gran-guerracom-origin --delete
