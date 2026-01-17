#!/usr/bin/env bash
set -euo pipefail

VERSION="$1"
UPSTREAM_REPO="https://github.com/YaLTeR/niri.git"

CI=${CI:-false}
ROOT_DIR="$(pwd)"
WORKDIR="$ROOT_DIR/build"

mkdir -p "$WORKDIR"
cd "$WORKDIR"

echo "==> CI mode: $CI"
echo "==> Building niri version $VERSION"

# Clean only inside build/, never repo root
rm -rf niri niri_*.orig.tar.xz *.deb *.changes *.buildinfo

echo "==> Cloning niri $VERSION"
git clone --branch "v$VERSION" --depth 1 "$UPSTREAM_REPO" niri
cd niri

echo "==> Injecting debian/ directory"
cp -r "$ROOT_DIR/debian" .

DATE="$(date -R)"
sed \
  -e "s/@VERSION@/${VERSION}/" \
  -e "s/@DATE@/${DATE}/" \
  debian/changelog.in > debian/changelog

rm debian/changelog.in

cd ..

echo "==> Creating orig tarball"
tar --exclude-vcs -cJf "niri_${VERSION}.orig.tar.xz" niri

cd niri

echo "==> Building package"
dpkg-buildpackage -us -uc

cd "$WORKDIR"

echo "==> Build artifacts:"
ls -lh *.deb *.changes *.buildinfo
