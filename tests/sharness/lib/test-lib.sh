# Test framework for multihash
#
# Copyright (c) 2016 Christian Couder
# MIT Licensed; see the LICENSE file in this repository.
#
# We are using sharness (https://github.com/chriscool/sharness)
# which was extracted from the Git test framework.

# Test the first 'multihash' tool available in the PATH.

# Add current bin directory to path, in case multihash tool is there.
PATH=$(pwd)/bin:${PATH}

# Set sharness verbosity. we set the env var directly as
# it's too late to pass in --verbose, and --verbose is harder
# to pass through in some cases.
test "$TEST_VERBOSE" = 1 && verbose=t

# Assert a `multihash` tool is available in the PATH.
type multihash >/dev/null || {
	echo >&2 "Cannot find any 'multihash' tool in '$PATH'."
	echo >&2 "Please make sure 'multihash' is in your PATH."
	exit 1
}

SHARNESS_LIB="lib/sharness/sharness.sh"

. "$SHARNESS_LIB" || {
	echo >&2 "Cannot source: $SHARNESS_LIB"
	echo >&2 "Please check Sharness installation."
	exit 1
}

# Please put multihash specific shell functions below

for hashbin in sha1sum shasum; do
	if type "$hashbin" >/dev/null; then
		export SHA1SUMBIN="$hashbin" &&
		test_set_prereq SHA1SUM &&
		break
	fi
done

