# multihash

Multihash is a protocol for differentiating outputs from various well-established cryptographic hash functions, addressing size + encoding considerations.

It is useful to write applications that future-proof their use of hashes, and allow multiple hash functions to coexist. See https://github.com/jbenet/random-ideas/issues/1 for a longer discussion.

## Example

Outputs of `<encoding>.encode(multihash(<digest>, <function>))`:

```
# sha1 - 0x11
11140beec7b5ea3f0fdbc95d0dd47f3c5bc275da8a33 # sha1 in hex
24a0qvp7pqn3y3yvt5egvn3z7hdw4xeuh8tg # sha1 in base32
5dqx43zNtUUbPj97vJhpHyUUPyrmXG # sha1 in base58
ERQL7se16j8P28ldDdR/PFvCddqKMw== # sha1 in base64

# sha2-256 0x12
12202c26b46b68ffc68ff99b453c1d30413413422d706483bfa0f98a5e886266e7ae # sha2-256 in hex
28g2r9nmddmfzhmfz6dmaf0x610k84u25nr690xzm3wrmqm8c9kefbg # sha256 in base32
QmRJzsvyCQyizr73Gmms8ZRtvNxmgqumxc2KUp71dfEmoj # sha256 in base58
EiAsJrRraP/Gj/mbRTwdMEE0E0ItcGSDv6D5il6IYmbnrg== # sha256 in base64
```

## Format

```
<varint hash function code><varint digest size in bytes><hash function output>
```

Binary example (only 4 bytes for simplicity):

```
fn code  dig size hash digest
-------- -------- ------------------------------------
00010001 00000100 101101100 11111000 01011100 10110101
sha1     4 bytes  4 byte sha1 digest
```

> Why have digest size as a separate number?

Because otherwise you end up with a function code really meaning "function-and-digest-size-code". Makes using custom digest sizes annoying, and is less flexible.

> Why isn't the size first?

Because aesthetically I prefer the code first. You already have to write your stream parsing code to understand that a single byte already means "a length in bytes more to skip". Reversing these doesn't buy you much.

> Why varints?

So that we have no limitation on functions or lengths.

> What kind of varints?

An Most Significant Bit unsigned varint, as defined by the [multiformats/unsigned-varint](https://github.com/multiformats/unsigned-varint).

> Don't we have to agree on a table of functions?

Yes, but we already have to agree on functions, so this is not hard. The table even leaves some room for custom function codes.

## Implementations:

- [go-multihash](//github.com/jbenet/go-multihash)
- [node-multihash](//github.com/jbenet/node-multihash)
- [clj-multihash](//github.com/greglook/clj-multihash)
- rust-multihash
  - [by @dignifiedquire](//github.com/dignifiedquire/rust-multihash)
  - [by @google](//github.com/google/rust-multihash)
- [haskell-multihash](//github.com/LukeHoersten/multihash)
- [python-multihash](//github.com/tehmaze/python-multihash)
- [elixir-multihash](//github.com/zabirauf/ex_multihash), [elixir-multihashing](//github.com/candeira/ex_multihashing)
- [swift-multihash](//github.com/NeoTeo/SwiftMultihash)
- [ruby-multihash](//github.com/neocities/ruby-multihash)
- [MultiHash.Net](//github.com/MCGPPeters/MultiHash.Net)
- [scala-multihash](//github.com/mediachain/scala-multihash)
- [php-multihash](//github.com/Fil/php-multihash)

## table for Multihash v1.0.0-RC (semver)

The current multihash table is [here](hashtable.csv):

```
code name
0x00 identity
0x11 sha1
0x12 sha2-256
0x13 sha2-512
0x14 sha3-512
0x15 sha3-384
0x16 sha3-256
0x17 sha3-224
0x18 shake-128
0x19 shake-256
0x40 blake2b
0x41 blake2s
# 0x00-0x0f reserved for application specific functions
# 0x10-0x3f reserved for SHA standard functions
# 0x14 formerly had the name "sha3", now deprecated
```


### other tables

Cannot find a good standard on this. Found some _different_ IANA ones:

- https://www.iana.org/assignments/tls-parameters/tls-parameters.xhtml#tls-parameters-18
- http://tools.ietf.org/html/rfc6920#section-9.4

They disagree. :(

## Disclaimers

Warning: **obviously multihash values bias the first two bytes**. Do not expect them to be uniformly distributed. The entropy size is `len(multihash) - 2`. Skip the first two bytes when using them with bloom filters, etc. Why not _ap_pend instead of _pre_pend? Because when reading a stream of hashes, you can know the length of the hash (from the table).

License: MIT
