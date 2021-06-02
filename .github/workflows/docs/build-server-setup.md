# Overview
The build server is currently hosted via Ionos (https://www.ionos.com/) as a dedicated server with AMD CPUs and an SSD.  This dedicated server is likely overkill (though helpful on slow 'full' builds that *still* take 5-6 hours), but does provide a good cost-benefit ratio compared to many statically provided cloud VMs - particularly in terms of disk space.  SSD's are helpful in running multiple builds at once as a HDD based system is quite unresponsive during intensive disk access.

In order to facilitate re-deploying on a new server, we have captured the deployment of the server into a `cloud-init` file.  The cloud-init file will need to be updated with a current github runner token for registering an action runner as well as ssh public keys to match the generated private keys.  This means this page is only useful to admins of the 351ELEC repository (or a fork wanting to run it's own builds).

# Deployment

The following `cloud-init` file can be used to deploy a new server when paired with an Ubuntu 20.04 image.  To summarize what the cloud-init is doing: 1. Setup an admin and build user. 2. Don't allow root ssh login.  3. Install docker 4. Install and register Github Action runners.

You will need to update the following variables in the cloud-init before deployment:

- **SSH keys** (`_SSH_PUBLIC_KEY_CLOUD_USER` and `__SSH_PUBLIC_KEY_BUILD_USER`) - for security, you should generate one for `cloud-user` (admin) and one for `build-user` (runs builds/troubleshooting - no sudo).
  - To generate, run: `ssh-keygen -t ed25519 -a 100` and put the content of the `*.pub` file that gets created below for `__SSH_PUBLIC_KEY_CLOUD_USER` and `__SSH_PUBLIC_KEY_BUILD_USER`
- **Github Runner Token** - You can find this in github in the 351ELEC repository under `settings` -> `actions` -> `runners` -> `Add Runner` (button) and copy the value in the `Configuration` section after `--token`.  Example: `AHIRSKSEMU4G7JQ2Z7X2UA3AW2TCC`.  NOTE: This token will only be valid for one hour, so you will need to provision the server within an hour.  You can also run register the runner manually after deployment.

- **(optional) Github Runner Name** - it is set to `build-server` currently. If you do not change this value, the new server will *replace* the existing github runners.  If you would like to register new/additional runners for testing, etc, change it to something new.

# cloud-init file
This file can be passed in when provisioning a host on most hosting providers. 

Ensure you've replaced `__SSH_PUBLIC_KEY_CLOUD_USER` (and `__SSH_PUBLIC_KEY_BUILD_USER`) or you will not be able to access the machine.  Ensure you've replaced: `__GITHUB_RUNNER_TOKEN` or the github runner will not register automatically.

```
#cloud-config
hostname: 351build-ssd
users:
  # cloud-user is the 'admin' user with sudo access - it is not used for builds
  #  login with this user to perform maintenance operations on the server
  #  A new public/private key can be generated with: ssh-keygen -t ed25519
  - name: cloud-user
    ssh-authorized-keys:
      - __SSH_PUBLIC_KEY_CLOUD_USER
    sudo: ['ALL=(ALL) NOPASSWD:ALL']
    groups: sudo, docker
    shell: /bin/bash

  # build user is the user used to run builds - it does not have sudo access for security purposes
  #  login with this user to troubleshoot failed builds
  #  A new public/private key can be generated with: ssh-keygen -t ed25519
  - name: build
    ssh-authorized-keys:
      - __SSH_PUBLIC_KEY_BUILD_USER
    groups: docker
    shell: /bin/bash
runcmd:
  # Set variables
  - export GITHUB_RUNNER_TOKEN=__GITHUB_RUNNER_TOKEN
  - export GITHUB_REPO=https://github.com/351ELEC/351ELEC
  - export BUILD_SERVER_NAME=build-server
  - export DEBIAN_FRONTEND=noninteractive
  - export MAIN_RUNNER_DIR=/var/runner
  - export PR_RUNNER_DIR=/var/runner-pr
  - export ACTION_RUNNER_VERSION=2.278.0
  - export ACTION_RUNNER_URL=https://github.com/actions/runner/releases/download/v${ACTION_RUNNER_VERSION}/actions-runner-linux-x64-${ACTION_RUNNER_VERSION}.tar.gz
  - export ACTION_RUNNER_TAR=./ar.tar.gz

  # Ionos specific - This is mainly needed for Ionos hosts which don't have disks take up full space.
  - echo "Expanding the disk for IONOS based system..."
  - lvextend -l +100%FREE /dev/vg00/var && resize2fs /dev/vg00/var || true
  
  # No root login for security
  - echo "Setting up SSH security..."
  - sed -i -e '/^PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
  - service sshd restart
  
  # Update and install needed packages
  - echo "Updating the OS..."

  - apt-get update
  - apt-get upgrade -y
  - apt-get install -y docker.io

  # Setup github action directories
  - echo "Setting up github runner directories..."
  - mkdir ${MAIN_RUNNER_DIR} && cd ${MAIN_RUNNER_DIR} && curl -o ${ACTION_RUNNER_TAR} -L ${ACTION_RUNNER_URL} && tar xzf ${ACTION_RUNNER_TAR} && rm ${ACTION_RUNNER_TAR}
  - mkdir ${PR_RUNNER_DIR} && cd ${PR_RUNNER_DIR} && curl -o ${ACTION_RUNNER_TAR} -L ${ACTION_RUNNER_URL}  && tar xzf ${ACTION_RUNNER_TAR} && rm ${ACTION_RUNNER_TAR}
  - chown -R build:build ${MAIN_RUNNER_DIR} ${PR_RUNNER_DIR}

  # Register Github Runners
  - echo "Registering github runners..."
    # main
  - runuser -l build -c "${MAIN_RUNNER_DIR}/config.sh  --url ${GITHUB_REPO} --token ${GITHUB_RUNNER_TOKEN} --unattended --name ${BUILD_SERVER_NAME} --labels main --replace"
  - cd ${MAIN_RUNNER_DIR} && ./svc.sh install build && ./svc.sh start
    # pr
  - runuser -l build -c "${PR_RUNNER_DIR}/config.sh  --url ${GITHUB_REPO} --token ${GITHUB_RUNNER_TOKEN} --unattended --name ${BUILD_SERVER_NAME}-pr --labels pr --replace"
  - cd ${PR_RUNNER_DIR} && ./svc.sh install build && ./svc.sh start
  

```
