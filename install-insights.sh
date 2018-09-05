#!/bin/bash

INSIGHTS_URL=""
LMS_URL=""

# Install required package
echo "Install Required Package for Insights"
sudo apt-get update -y
sudo apt-get install -y git python-pip python-dev libmysqlclient-dev python-mysqldb build-essential
sudo pip install virtualenv

# Crate Ansible virtualenv
echo "Create Virtualenv and Activate it"
virtualenv ansible
. ansible/bin/activate

# Clone Repository
git clone https://github.com/ariestiyansyah/configuration.git
cd configuration/
pip install -r requirements.txt
cd playbooks/edx-east/

# Running Ansible
echo "Running Ansible, this may take a while..."

ansible-playbook -i localhost, -c local analytics_single.yml --extra-vars "INSIGHTS_LMS_BASE=$LMS_URL INSIGHTS_BASE_URL=$INSIGHTS_URL"

# Setup Analytic Pipeline
echo "Setup Analytics Pipeline"

# Create Pipeline virtualenv
echo "Making pipeline virtualenv"
virtualenv pipeline
. pipeline/bin/activate

# Clone Analytics Pipeline
echo "Check out pipeline"
git clone https://github.com/edx/edx-analytics-pipeline
cd edx-analytics-pipeline

