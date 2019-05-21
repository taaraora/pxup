#!/bin/sh

. utils.sh

pullimage=$(getvar pullimage)
pximage=$(getvar pximage)

if [ "pullimage" = "false" ] ; then
	docker save ${pximage} > $PWD/roles/common/files/px.img
fi

vagrant up --provider=libvirt --no-provision $@ \
    && vagrant --provider=libvirt provision

