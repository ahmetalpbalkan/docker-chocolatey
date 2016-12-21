#!/bin/bash

if [ "$1" = "" ]; then
  echo "Usage: $0 version"
  echo "Update the choco package to a given version"
  echo "Example: $0 1.10.3"
  exit 1
fi

if [[ "${OSTYPE}" != "darwin"* && "${OSTYPE}" != "linux-gnu"* ]]; then
  echo "This version support Mac and Windows Subsystem for Linux"
  exit 2
fi

version=$1

uri="get"

if [[ $version = *"-rc"* ]]
then
  uri="test"
fi

url="https://${uri}.docker.com/builds/Windows/i386/docker-${version}.zip"
url64="https://${uri}.docker.com/builds/Windows/x86_64/docker-${version}.zip"
checksum=$(curl "${url}.md5" | cut -f 1 -d " ")
checksum64=$(curl "${url64}.md5" | cut -f 1 -d " ")

sed -i.bak "s/<version>.*<\/version>/<version>${version}<\/version>/" docker.nuspec

sed -i.bak "s/version: .*{build}/version: ${version}.{build}/" appveyor.yml

sed -i.bak "s!^\$url            = '.*'!\$url            = '${url}'!" tools/chocolateyInstall.ps1
sed -i.bak "s/^\$checksum       = '.*'/\$checksum       = '${checksum}'/" tools/chocolateyInstall.ps1
sed -i.bak "s!^\$url64          = '.*'!\$url64          = '${url64}'!" tools/chocolateyInstall.ps1
sed -i.bak "s/^\$checksum64     = '.*'/\$checksum64     = '${checksum64}'/" tools/chocolateyInstall.ps1
