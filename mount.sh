#!/bin/bash

set -eo pipefail

if [[ $# = 1 ]]; then
	fullip="$1"
elif [[ $# = 2 && ("$2" = "--force" || "$2" = "-f") ]]; then
	fullip="$1"
	force="true"
else
	echo "Usage: $0 <ip>[:port] [--force|-f]" >&2
	exit 1
fi

ip="$(echo "${fullip}" | cut -d: -f1)"
if [[ "${fullip}" = *":"* ]]; then
	args=("${ip}" -p "$(echo "${fullip}" | cut -d: -f2)")
else
	args=("${ip}")
fi

cd "$(dirname "$0")"

rm -rf staging
rootdir="${PWD}"
function cleanup {
	rm -rf "${rootdir}/staging"
}
trap cleanup EXIT

if [[ "${force}" != "true" ]] && ssh "${args[@]}" "mount | grep -q '/Developer .* union'"; then
	echo "Error: Already mounted. Use --force to override." >&2
	exit 1
fi

if ! ssh "${args[@]}" "test -d /Developer"; then
	echo "Error: Please prepare your device for development using Xcode first." >&2
	exit 1
fi

version="$(ssh "${args[@]}" sw_vers | grep ProductVersion | cut -d" " -f2 | cut -d. -f -2)"
image_name="ddi-${version}.dmg"

mkdir -p images

if [[ ! -f "images/${image_name}" ]]; then
	mkdir staging
	pushd staging
	cp "$(xcode-select -p)/Platforms/iPhoneOS.platform/DeviceSupport/${version}/DeveloperDiskImage.dmg" DeveloperDiskImage.dmg
	hdiutil attach -owners on DeveloperDiskImage.dmg -shadow -mountpoint ddi

	function cleanup2 {
		[[ -d "${rootdir}/staging/ddi" ]] && hdiutil detach "${rootdir}/staging/ddi"
		cleanup
	}
	trap cleanup2 EXIT

	sudo mv ddi/usr/bin/debugserver .
	sudo ldid -S../ent.xml debugserver
	sudo rm -rf ddi/*
	sudo mkdir -p ddi/usr/bin
	sudo mv debugserver ddi/usr/bin
	hdiutil detach ddi
	popd
	hdiutil convert -format UDZO -o images/"${image_name}" staging/DeveloperDiskImage.dmg -shadow
fi

ssh "${args[@]}" -l root 'cat > /tmp/ddi-patched.dmg && mount -o union,ro -t hfs `hdik /tmp/ddi-patched.dmg` /Developer' < "images/${image_name}" 2>&1 | { grep -Fv 'mount_hfs: Could not create property for re-key environment check: No such process' || :; }

echo 'Done!'
