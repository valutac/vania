#!/bin/sh
cd ~

# set locales
export LC_ALL="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"

read -p 'Enter Open edX Release (ex:open-release/hawthorn.1): ' release

export OPENEDX_RELEASE=$release
# Bootstrap the Ansible installation:
wget https://raw.githubusercontent.com/edx/configuration/$OPENEDX_RELEASE/util/install/ansible-bootstrap.sh -O - | sudo -H bash

# (Optional) If this is a new installation, randomize the passwords:
wget https://raw.githubusercontent.com/edx/configuration/$OPENEDX_RELEASE/util/install/generate-passwords.sh -O - | bash

# Install Open edX:
wget https://raw.githubusercontent.com/edx/configuration/$OPENEDX_RELEASE/util/install/native.sh -O - | bash > openedxlog.out