#!/bin/sh

test_description="Test multihash basics"

. lib/test-lib.sh

test_expect_success "current dir is writable" '
	echo "It works!" >test.txt
'

test_expect_success "'$MULTIHASH_BIN --help' looks good" '
	"$MULTIHASH_BIN" --help >actual 2>&1 || true &&
	egrep -i "usage" actual >/dev/null
'

for opt in algorithm check encoding length quiet help
do 
	test_expect_success "'$MULTIHASH_BIN --help' mention -$opt option" '
		egrep "[-]$opt" actual >/dev/null
	'
done

test_expect_success "'$MULTIHASH_BIN test.txt' works" '
	"$MULTIHASH_BIN" test.txt >actual
'

test_expect_success "'$MULTIHASH_BIN test.txt' output looks good" '
	echo "QmTwovvskpD1hzuJA8wLA73wjxSisrVknKeNvGZVyjDguU" >expected &&
	test_cmp expected actual
'

test_done

# vi: set ft=sh :
