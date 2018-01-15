#!/bin/bash

# Initial provining

set -e
set -o pipefail

sudo yum update -y

sudo yum -y install epel-release && sudo yum -y install python-pip && sudo pip install ansible==2.4.0

sudo pip install awscli