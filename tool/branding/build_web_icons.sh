#!/usr/bin/env bash
# Render the brand SVGs in this folder into the PNGs the web build and
# link-preview crawlers use. Requires Inkscape on PATH.
#
#   bash tool/branding/build_web_icons.sh
#
set -euo pipefail

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
web="$here/../../web"

render() { # src  out  w  h
  inkscape "$here/$1" --export-type=png --export-filename="$2" -w "$3" -h "$4"
}

render icon-src.svg          "$web/favicon.png"                 64   64
render icon-src.svg          "$web/icons/Icon-192.png"          192  192
render icon-src.svg          "$web/icons/Icon-512.png"          512  512
render icon-maskable-src.svg "$web/icons/Icon-maskable-192.png" 192  192
render icon-maskable-src.svg "$web/icons/Icon-maskable-512.png" 512  512
render og-src.svg            "$web/og-image.png"                1200 630

echo "Done. Rendered web icons + og-image."
