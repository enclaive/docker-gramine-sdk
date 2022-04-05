#!/bin/bash

set -euxo pipefail

#################################################################################
# bash variant of systemd service file at /usr/lib/systemd/system/aesmd.service #
export NAME=aesm_service
export AESM_PATH=/opt/intel/sgx-aesm-service/aesm
export LD_LIBRARY_PATH=/opt/intel/sgx-aesm-service/aesm

cd /opt/intel/sgx-aesm-service/aesm

/opt/intel/sgx-aesm-service/aesm/linksgx.sh
/bin/mkdir -p /var/run/aesmd/
/bin/chown -R aesmd:aesmd /var/run/aesmd/
/bin/chmod 0755 /var/run/aesmd/
/bin/chown -R aesmd:aesmd /var/opt/aesmd/
/bin/chmod 0750 /var/opt/aesmd/

#strace -ff -a 128 /opt/intel/sgx-aesm-service/aesm/aesm_service 2>&1
/opt/intel/sgx-aesm-service/aesm/aesm_service &
AESM_PID=$!
################################################################################

/bin/bash
