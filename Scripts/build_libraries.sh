#!/bin/sh
set -ex

SCRIPT_DIR=`dirname "$0"`

# (cd "$SCRIPT_DIR" && sh build_secp256k1.sh)
(cd "$SCRIPT_DIR" && sh build_crypto.sh)

exit 0


# XCode build phase
#
# if [ ! -d "$SRCROOT/Libraries/secp256k1/lib" ] || [ ! -d "$SRCROOT/Libraries/openssl/lib" ]; then
#  env -i PATH=$PATH sh "$SRCROOT/setup/build_libraries.sh"
# fi 
