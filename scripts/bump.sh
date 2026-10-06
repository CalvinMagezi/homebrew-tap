#!/usr/bin/env bash
# Regenerates Formula/agent-hq.rb from the signed stable release manifest of CalvinMagezi/hq.
# Hashes are written only after the channel pointer and the manifest signatures verify
# against the project's minisign key, using OpenSSL 1.1.1+ (no extra tools).
set -euo pipefail

REPO="${HQ_REPO:-CalvinMagezi/hq}"
CHANNEL="${HQ_CHANNEL:-stable}"
PUBKEY_LINE="RWTSi05PPMb9UVVnGilhLWT7h/mjQ1VjfAEXszxJB/Er8UEsCXFc3o1/"
BASE="https://github.com/$REPO/releases/download"
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

die() { echo "bump: $*" >&2; exit 1; }

verify_minisign_openssl() {
    local msg="$1" sigfile="$2" w ok=1
    w="$(mktemp -d)"
    {
        printf '%s' "$PUBKEY_LINE" | base64 -d > "$w/pub.raw" 2>/dev/null &&
        [ "$(wc -c < "$w/pub.raw" | tr -d ' ')" -eq 42 ] &&
        [ "$(head -c 2 "$w/pub.raw")" = "Ed" ] &&
        tail -c 32 "$w/pub.raw" > "$w/key.raw" &&
        { printf '\x30\x2a\x30\x05\x06\x03\x2b\x65\x70\x03\x21\x00'; cat "$w/key.raw"; } > "$w/pub.der" &&
        sed -n 2p "$sigfile" | base64 -d > "$w/sig.raw" 2>/dev/null &&
        [ "$(wc -c < "$w/sig.raw" | tr -d ' ')" -eq 74 ] &&
        [ "$(head -c 2 "$w/sig.raw")" = "ED" ] &&
        [ "$(dd if="$w/sig.raw" bs=1 skip=2 count=8 2>/dev/null | od -An -tx1 | tr -d ' \n')" = "$(dd if="$w/pub.raw" bs=1 skip=2 count=8 2>/dev/null | od -An -tx1 | tr -d ' \n')" ] &&
        tail -c 64 "$w/sig.raw" > "$w/sig.bin" &&
        openssl dgst -blake2b512 -binary "$msg" > "$w/hash.bin" &&
        openssl pkeyutl -verify -pubin -inkey "$w/pub.der" -keyform DER -rawin -in "$w/hash.bin" -sigfile "$w/sig.bin" >/dev/null 2>&1 &&
        { sed -n 3p "$sigfile" | sed 's/^trusted comment: //' | tr -d '\r\n' > "$w/comment.txt"; } &&
        sed -n 4p "$sigfile" | base64 -d > "$w/global.bin" 2>/dev/null &&
        [ "$(wc -c < "$w/global.bin" | tr -d ' ')" -eq 64 ] &&
        { cat "$w/sig.bin" "$w/comment.txt"; } > "$w/global.msg" &&
        openssl pkeyutl -verify -pubin -inkey "$w/pub.der" -keyform DER -rawin -in "$w/global.msg" -sigfile "$w/global.bin" >/dev/null 2>&1
    } && ok=0
    rm -rf "$w"
    return "$ok"
}

sha256_of() { if command -v sha256sum >/dev/null 2>&1; then sha256sum "$1" | cut -d' ' -f1; else shasum -a 256 "$1" | cut -d' ' -f1; fi; }

work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT
fetch() { curl --proto '=https' --tlsv1.2 -fsSL --max-time 120 -o "$2" "$1" || die "could not download $1"; }

fetch "$BASE/channel-$CHANNEL/channel-$CHANNEL.json" "$work/channel.json"
fetch "$BASE/channel-$CHANNEL/channel-$CHANNEL.json.minisig" "$work/channel.json.minisig"
verify_minisign_openssl "$work/channel.json" "$work/channel.json.minisig" || die "channel pointer signature does not verify"
[ "$(jq -er .channel "$work/channel.json")" = "$CHANNEL" ] || die "wrong channel in pointer"
version="$(jq -er .version "$work/channel.json")"
manifest_url="$(jq -er .manifest_url "$work/channel.json")"
printf '%s' "$version" | grep -Eq '^[A-Za-z0-9._+-]+$' || die "unexpected version string"
case "$manifest_url" in "$BASE"/*) ;; *) die "manifest URL outside $BASE" ;; esac

fetch "$manifest_url" "$work/manifest.json"
fetch "$manifest_url.minisig" "$work/manifest.json.minisig"
[ "$(sha256_of "$work/manifest.json")" = "$(jq -er .manifest_sha256 "$work/channel.json")" ] || die "manifest does not match the pointer"
verify_minisign_openssl "$work/manifest.json" "$work/manifest.json.minisig" || die "manifest signature does not verify"
[ "$(jq -er .version "$work/manifest.json")" = "$version" ] || die "manifest version differs from the pointer"

sha_for() {
    jq -er --arg n "hq-$version-$1.tar.gz" '.artifacts[] | select(.name == $n) | .sha256' "$work/manifest.json" \
        || die "release $version has no $1 build"
}
darwin_arm="$(sha_for darwin-aarch64)"
linux_arm="$(sha_for linux-aarch64)"
linux_x86="$(sha_for linux-x86_64)"
for h in "$darwin_arm" "$linux_arm" "$linux_x86"; do
    printf '%s' "$h" | grep -Eq '^[0-9a-f]{64}$' || die "malformed sha256 in manifest"
done

sed -e "s|@VERSION@|$version|g" \
    -e "s|@SHA_DARWIN_ARM@|$darwin_arm|g" \
    -e "s|@SHA_LINUX_ARM@|$linux_arm|g" \
    -e "s|@SHA_LINUX_X86@|$linux_x86|g" \
    -e "s|@REPO@|$REPO|g" \
    "$HERE/scripts/agent-hq.rb.in" > "$HERE/Formula/agent-hq.rb"
echo "bump: Formula/agent-hq.rb now at $version"
