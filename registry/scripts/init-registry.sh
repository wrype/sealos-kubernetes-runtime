#!/bin/bash
# Copyright © 2022 sealos.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
cd "$(dirname "$0")" >/dev/null 2>&1 || exit
source common.sh

readonly DATA=${1:-/var/lib/registry}
readonly CONFIG=${2:-/etc/registry}

mkdir -p "$DATA" "$CONFIG"

cp -a ../etc/registry.service /etc/systemd/system/
cp -au ../cri/registry /usr/bin/

cp -a ../etc/registry_config.yml "$CONFIG"
cp -a ../etc/registry_htpasswd "$CONFIG"

if [ -s /etc/selinux/config ] && grep 'SELINUX=enforcing' /etc/selinux/config; then
    sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
    setenforce 0
fi

check_service start registry
check_status registry

logger "init registry success"
