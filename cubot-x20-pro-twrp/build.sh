#!/bin/bash
set -e
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y git-core gnupg flex bison build-essential zip curl zlib1g-dev gcc-multilib g++-multilib \
  libc6-dev-i386 lib32ncurses5-dev x11proto-core-dev libx11-dev lib32z1-dev libgl1-mesa-dev libxml2-utils \
  xsltproc unzip fontconfig openjdk-8-jdk python python3 bc rsync lz4 libssl-dev ca-certificates
curl -s https://storage.googleapis.com/git-repo-downloads/repo -o /usr/local/bin/repo
chmod +x /usr/local/bin/repo
git config --global user.email "ci@example.com"
git config --global user.name "ci"
git config --global color.ui false
mkdir -p /twrp && cd /twrp
repo init --no-repo-verify -u https://github.com/minimal-manifest-twrp/platform_manifest_twrp_omni.git -b twrp-9.0 --depth=1
repo sync -c -j4 --no-tags --no-clone-bundle --force-sync
mkdir -p device/cubot
rm -rf device/cubot/X20_Pro
cp -r /src/device/cubot/X20_Pro device/cubot/
export ALLOW_MISSING_DEPENDENCIES=true
export LC_ALL=C
source build/envsetup.sh
lunch omni_X20_Pro-eng
mka recoveryimage -j"$(nproc)"
ls -l out/target/product/X20_Pro/recovery.img
