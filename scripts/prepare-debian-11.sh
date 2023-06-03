#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#
#  Author: Hari Sekhon
#  Date: 2023-06-03 02:04:01 +0100 (Sat, 03 Jun 2023)
#
#  https://github.com/HariSekhon/Packer-templates
#
#  License: see accompanying Hari Sekhon LICENSE file
#
#  If you're using my code you're welcome to connect with me on LinkedIn and optionally send me feedback to help steer this or other code I publish
#
#  https://www.linkedin.com/in/HariSekhon
#

# Downloads the Debian ISO and generates an ISO with the preseed.cfg config on which to boot the tart

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

iso="debian-11.7.0-arm64-DVD-1.iso"

mkdir -p -v "$srcdir/../isos"

cd "$srcdir/../isos"

url="https://cdimage.debian.org/debian-cd/current/arm64/iso-dvd/$iso"

# shellcheck disable=SC2064
#trap "rm -f '$iso'" EXIT
echo "Downloading Debian ISO..."
wget -cO "$iso" "$url"
echo

cidata_base="debian-11_cidata"
cidata="$cidata_base/cidata"  # last component must be called 'cidata' for auto-booting

if [ -d "$cidata_base" ]; then
	rm -rf "$cidata_base"*
fi

echo "Creating staging dir '$cidata'"
mkdir -pv "$cidata"
echo

cp -v "$srcdir/../installers/preseed.cfg" "$cidata/"
echo

#trap 'rm -f "$cidata_base.iso"' EXIT

echo "Creating '$cidata_base.iso'"
hdiutil makehybrid -o "$cidata_base.iso" "$cidata" -joliet -iso
echo

#trap '' EXIT

echo "Debian ISOs prepared"
