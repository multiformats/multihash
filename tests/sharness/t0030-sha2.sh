#!/bin/sh
#
# Copyright (c) 2016 Christian Couder
# MIT Licensed; see the LICENSE file in this repository.
#

test_description="sha2 tests"

. lib/test-lib.sh

test_expect_success "setup sha2 tests" '
	echo "Hash me!" >hash_me.txt &&
	SHA256=c16bdce7e126ff8e241a9893ccd908c292cd0e54c403145326eb0c567071a613 &&
	SHA512=4c4a59a7d958cff035eb7d752b319b90337037e352b89d58aa5be29ef051ea0a565133781aa3279384654274c4786893287ea8037f0a1a15d9b40ea0bc4be73c &&
	echo "1220$SHA256" >expected256 &&
	echo "1340$SHA512" >expected512
'

test_expect_success "'$MULTIHASH_BIN -a=sha2-256 -e=hex' works" '
	"$MULTIHASH_BIN" -a=sha2-256 -e=hex hash_me.txt >actual256
'

test_expect_success "'$MULTIHASH_BIN -a=sha2-256 -e=hex' output looks good" '
	test_cmp expected256 actual256
'

test_expect_success "'$MULTIHASH_BIN -a=sha2-512 -e=hex' works" '
	"$MULTIHASH_BIN" -a=sha2-512 -e=hex hash_me.txt >actual512
'

test_expect_success "'$MULTIHASH_BIN -a=sha2-512 -e=hex' output looks good" '
	test_cmp expected512 actual512
'

test_expect_success SHA256SUM "check sha2-256 hash using '$SHA256SUMBIN'" '
	echo "$SHA256  hash_me.txt" >expected &&
	$SHA256SUMBIN hash_me.txt >actual &&
	test_cmp expected actual
'

test_expect_success SHA512SUM "check sha2-512 hash using '$SHA512SUMBIN'" '
	echo "$SHA512  hash_me.txt" >expected &&
	$SHA512SUMBIN hash_me.txt >actual &&
	test_cmp expected actual
'

test_done
