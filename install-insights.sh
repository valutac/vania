#!/bin/bash

# set locales
export LC_ALL="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"

# Set Open edX release, currently support ginkgo
read -p 'Specify the Open edX release (example: open-release/hawthorn.master): ' openedxrelease
read -p 'Enter Insight URL: ' insighturl
read -p 'Enter LMS URL: ' lmsurl
read -p 'Enter LMS MYSQL Password (find it on lms.auth.json): ' dbpassword

# Set variable
OPENEDX_RELEASE="$openedxrelease"
INSIGHTS_URL="$insighturl"
LMS_URL="$lmsurl"
DB_USERNAME="edxapp001"
DB_HOST="localhost"
DB_PASSWORD="$dbpassword"
DB_PORT="3306"

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
cd ~
# Create Pipeline virtualenv
echo "Making pipeline virtualenv"
virtualenv pipeline
. pipeline/bin/activate

# Clone Analytics Pipeline
echo "Check out pipeline"
git clone -b $OPENEDX_RELEASE https://github.com/edx/edx-analytics-pipeline
cd edx-analytics-pipeline
pip install -r requirements/pip.txt
pip install -r requirements/base.txt --no-cache-dir
python setup.py install --force

# Update Database credentials
cat <<EOF > /edx/etc/edx-analytics-pipeline/input.json
{"username": $DB_USERNAME, "host": $DB_HOST, "password": $DB_PASSWORD, "port": $DB_PORT}
EOF

# Running Pipeline
echo "Running Pipeline"
remote-task --host localhost --repo https://github.com/edx/edx-analytics-pipeline --user $USER --override-config $HOME/edx-analytics-pipeline/config/devstack.cfg --remote-name analyticstack --wait TotalEventsDailyTask --interval 2018 --output-root hdfs://localhost:9000/output/ --local-scheduler

echo "Installation completed"
