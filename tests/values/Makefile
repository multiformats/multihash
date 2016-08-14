
main: test_cases.csv

clean:
	rm -f random_vals.csv test_cases.csv

# multihash random_vals with all hash functions
test_cases.csv: random_vals.csv
	./gen_multihashes.py <$^ >$@

# make some random values
random_vals.csv:
	./gen_random.py 20 42 >$@

# make sure a multihash is installed
deps:
	@multihash <gen_random.py >/dev/null || (echo "a multihash binary must be installed" && exit 1)
