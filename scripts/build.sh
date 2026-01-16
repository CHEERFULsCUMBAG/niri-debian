#!/usr/bin/env bash
set -euo pipefail

VERSION="$1"
UPSTREAM_REPO="https://github.com/YaLTeR/niri.git"

WORKDIR="$(pwd)/build"
rm -rf "$WORKDIR"
mkdir -p "$WORKDIR"
cd "$WORKDIR"

echo "==> Cloning niri $VERSION"
git clone --branch "v$VERSION" --depth 1 "$UPSTREAM_REPO" niri
cd niri

echo "==> Creating orig tarball"
cd ..
tar --exclude-vcs -cJf "niri_${VERSION}.orig.tar.xz" niri
cd niri

echo "==> Injecting debian/ directory"
cp -r ../../debian .

DATE="$(date -R)"
sed \
  -e "s/@VERSION@/${VERSION}/" \
  -e "s/@DATE@/${DATE}/" \
  debian/changelog.in > debian/changelog

rm debian/changelog.in

echo "==> Building package"
dpkg-buildpackage -us -uc

echo "==> Build complete"
ls -1 ../*.deb
