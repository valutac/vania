#!/bin/bash
export OPENEDX_RELEASE=open-release/ginkgo.master

INSIGHTS_URL=""
LMS_URL=""

# Install required package
echo "Install Required Package for Insights"
sudo apt-get update -y
sudo apt-get install -y git python-pip python-dev libssl-dev libffi-dev libmysqlclient-dev python-mysqldb build-essential
sudo pip install virtualenv

# Generate SSH KEY
echo "Generate ssh key"
ssh-keygen -t rsa -f ~/.ssh/id_rsa -P ''
echo >> ~/.ssh/authorized_keys # Make sure there's a newline at the end
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

# Crate Ansible virtualenv
echo "Create Virtualenv and Activate it"
virtualenv ansible
. ansible/bin/activate

# Clone Repository
git clone -b $OPENEDX_RELEASE https://github.com/ariestiyansyah/configuration.git
cd configuration/
pip install -r requirements.txt
cd playbooks/edx-east/

# Running Ansible
echo "Running Ansible, this may take a while..."

ansible-playbook -i localhost, -c local analytics_single.yml --extra-vars "INSIGHTS_LMS_BASE=$LMS_URL INSIGHTS_BASE_URL=$INSIGHTS_URL"

# Copy Trackinglog, make sure you download it before
echo "copy tracking log"
cd $HOME
sudo mkdir -p /edx/var/log/tracking
sudo cp ~/tracking.log /edx/var/log/tracking
sudo chown hadoop /edx/var/log/tracking/tracking.log

# Logs to HDFS
echo "loading logs to HDFS..."
sleep 60

# Setup Analytic Pipeline
echo "Setup Analytics Pipeline"

# Create Pipeline virtualenv
echo "Making pipeline virtualenv"
virtualenv pipeline
. pipeline/bin/activate

# Clone Analytics Pipeline
echo "Check out pipeline"
git clone -b $OPENEDX_RELEASE https://github.com/edx/edx-analytics-pipeline
cd edx-analytics-pipeline

