#!/bin/sh
# Exit script when command fails
set -o errexit
# if any of the commands in pipeline fails, script will exit
set -o pipefail

. ./utils.sh

pullimage=$(getvar pullimage)
pximage=$(getvar pximage)

if vagrant box list | grep -q "taaraora/centos7"; then
  echo "taaraora/centos7 box is already added"
else
  echo "taaraora/centos7 box not found"
  vagrant box add --clean taaraora/centos7
fi

if [ $pullimage = "false" ] ; then
	echo "Copying docker ${pximage} ..."
	docker save ${pximage} > $PWD/roles/common/files/px.img
fi

vagrant up --provider=libvirt --no-provision $@ \
    && vagrant --provider=libvirt provision

