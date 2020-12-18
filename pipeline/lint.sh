#!/bin/bash
set -xe

TERRAFORM="${TERRAFORM:-terraform-0.12.29}"

"${TERRAFORM}" -v

cp providers.tf.example providers.tf
"${TERRAFORM}" init
"${TERRAFORM}" fmt -check=true
"${TERRAFORM}" validate -var "deployment_id=validate" -var "route53_domain=validate-fake.com" -var "admin_email=fake@mailinator.com"
find examples -maxdepth 1 -mindepth 1 -type d | while read -r example ; do
  cp providers.tf "${example}"
  (
    cd "${example}"
    echo "${example}"
    "${TERRAFORM}" init
    "${TERRAFORM}" fmt -check=true
    "${TERRAFORM}" validate -var "deployment_id=citest"
  )
done