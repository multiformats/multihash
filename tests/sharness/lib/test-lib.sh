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

# Assert a multihash tool, either given by the MULTIHASH_BIN env
# variable or called 'multihash', is available.
if test -n "$MULTIHASH_BIN"
then
	echo "Testing '$MULTIHASH_BIN' from MULTIHASH_BIN env variable."
else
	echo "Testing 'multihash' as MULTIHASH_BIN env variable is empty."
	MULTIHASH_BIN="multihash"
fi
export MULTIHASH_BIN
type "$MULTIHASH_BIN" >/dev/null || {
	echo >&2 "Cannot find '$MULTIHASH_BIN'."
	echo >&2 "Please make sure it is either:"
	echo >&2 "  - a path to an executable file, or"
	echo >&2 "  - the name of an executable file in your PATH ($PATH)."
	exit 1
}

SHARNESS_LIB="lib/sharness/sharness.sh"

. "$SHARNESS_LIB" || {
	echo >&2 "Cannot source: $SHARNESS_LIB"
	echo >&2 "Please check Sharness installation."
	exit 1
}

# Please put multihash specific shell functions below

if type shasum >/dev/null; then
		export SHA1SUMBIN="shasum" &&
		test_set_prereq SHA1SUM &&
		export SHA256SUMBIN="shasum -a 256" &&
		test_set_prereq SHA256SUM &&
		export SHA512SUMBIN="shasum -a 512" &&
		test_set_prereq SHA512SUM
else
	if type sha1sum >/dev/null; then
		export SHA1SUMBIN="sha1sum" &&
		test_set_prereq SHA1SUM
	fi
	if type sha256sum >/dev/null; then
		export SHA256SUMBIN="sha256sum" &&
		test_set_prereq SHA256SUM
	fi
	if type sha512sum >/dev/null; then
		export SHA512SUMBIN="sha512sum" &&
		test_set_prereq SHA512SUM
	fi
fi
