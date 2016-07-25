#!/bin/bash

if [ "$1" = "" ]; then
  echo "Usage: $0 rcversion"
  echo "Update the choco package to a given rcversion"
  echo "Example: $0 1.12.0-rc4"
  exit 1
fi

if [[ "${OSTYPE}" != "darwin"* ]]; then
  echo "This version does only support Mac."
  exit 2
fi

version=$1

url="https://test.docker.com/builds/Windows/i386/docker-${version}.zip"
url64="https://test.docker.com/builds/Windows/x86_64/docker-${version}.zip"
checksum=$(curl "${url}.md5" | cut -f 1 -d " ")
checksum64=$(curl "${url64}.md5" | cut -f 1 -d " ")

sed -i.bak "s/<version>.*<\/version>/<version>${version}<\/version>/" docker.nuspec

sed -i.bak "s/version: .*{build}/version: ${version}.{build}/" appveyor.yml

sed -i.bak "s!^\$url            = '.*'!\$url            = '${url}'!" tools/chocolateyInstall.ps1
sed -i.bak "s/^\$checksum       = '.*'/\$checksum       = '${checksum}'/" tools/chocolateyInstall.ps1
sed -i.bak "s!^\$url64          = '.*'!\$url64          = '${url64}'!" tools/chocolateyInstall.ps1
sed -i.bak "s/^\$checksum64     = '.*'/\$checksum64     = '${checksum64}'/" tools/chocolateyInstall.ps1
