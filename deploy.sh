#!/bin/bash

thumbsup && aws s3 sync ./s3album/*.{js,html} s3://jg-production-gran-guerracom-origin --delete
