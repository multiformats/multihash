# multihash

[![](https://img.shields.io/badge/made%20by-Protocol%20Labs-blue.svg?style=flat-square)](https://protocol.ai/)
[![](https://img.shields.io/badge/project-multiformats-blue.svg?style=flat-square)](https://github.com/multiformats/multiformats)
[![](https://img.shields.io/badge/freenode-%23ipfs-blue.svg?style=flat-square)](https://webchat.freenode.net/?channels=%23ipfs)
[![](https://img.shields.io/badge/readme%20style-standard-brightgreen.svg?style=flat-square)](https://github.com/RichardLitt/standard-readme)

> Self identifying hashes

Multihash is a protocol for differentiating outputs from various well-established cryptographic hash functions, addressing size + encoding considerations.

It is useful to write applications that future-proof their use of hashes, and allow multiple hash functions to coexist. See [jbenet/random-ideas#1](https://github.com/jbenet/random-ideas/issues/1) for a longer discussion.

## Table of Contents

- [Table of Contents](#table-of-contents)
- [Example](#example)
- [Format](#format)
- [Implementations](#implementations)
- [Table for Multihash](#table-for-multihash)
- [Prior Art And Translation](#prior-art-and-translation)
  - [Named Information Hash](#named-information-hash)
    - [Translation from multihash to named-information hash](#translation-from-multihash-to-named-information-hash)
  - [Namespaced UUIDs](#namespaced-uuids)
- [Notes](#notes)
  - [Multihash and randomness](#multihash-and-randomness)
  - [Insecure / obsolete hash functions](#insecure--obsolete-hash-functions)
  - [Non-cryptographic hash functions](#non-cryptographic-hash-functions)
- [Visual Examples](#visual-examples)
    - [Consider these 4 different hashes of same input](#consider-these-4-different-hashes-of-same-input)
    - [Same length: 256 bits](#same-length-256-bits)
    - [Different hash functions](#different-hash-functions)
    - [Idea: self-describe the values to distinguish](#idea-self-describe-the-values-to-distinguish)
    - [Multihash: fn code + length prefix](#multihash-fn-code--length-prefix)
    - [Multihash: a pretty good multiformat](#multihash-a-pretty-good-multiformat)
    - [Multihash: has a bunch of implementations already](#multihash-has-a-bunch-of-implementations-already)
- [Contribute](#contribute)
- [References](#references)
- [License](#license)

## Example

Outputs of `<encoding>.encode(multihash(<digest>, <function>))`:

```
# sha1 - 0x11 - sha1("multihash")
111488c2f11fb2ce392acb5b2986e640211c4690073e # sha1 in hex
CEKIRQXRD6ZM4OJKZNNSTBXGIAQRYRUQA47A==== # sha1 in base32
5dsgvJGnvAfiR3K6HCBc4hcokSfmjj # sha1 in base58
ERSIwvEfss45KstbKYbmQCEcRpAHPg== # sha1 in base64

# sha2-256 0x12 - sha2-256("multihash")
12209cbc07c3f991725836a3aa2a581ca2029198aa420b9d99bc0e131d9f3e2cbe47 # sha2-256 in hex
CIQJZPAHYP4ZC4SYG2R2UKSYDSRAFEMYVJBAXHMZXQHBGHM7HYWL4RY= # sha256 in base32
QmYtUc4iTCbbfVSDNKvtQqrfyezPPnFvE33wFmutw9PBBk # sha256 in base58
EiCcvAfD+ZFyWDajqipYHKICkZiqQgudmbwOEx2fPiy+Rw== # sha256 in base64
```

Note: You should consider using [multibase](https://github.com/multiformats/multibase) to base-encode these hashes instead of base-encoding them directly.

## Format

```
<varint hash function code><varint digest size in bytes><hash function output>
```

Binary example (only 4 bytes for simplicity):

```
fn code  dig size hash digest
-------- -------- -----------------------------------
00010001 00000100 10110110 11111000 01011100 10110101
sha1     4 bytes  4 byte sha1 digest
```

> Why have digest size as a separate number?

Because otherwise you end up with a function code really meaning "function-and-digest-size-code". Makes using custom digest sizes annoying, and is less flexible.

> Why isn't the size first?

Because aesthetically I prefer the code first. You already have to write your stream parsing code to understand that a single byte already means "a length in bytes more to skip". Reversing these doesn't buy you much.

> Why varints?

So that we have no limitation on functions or lengths.

> What kind of varints?

A Most Significant Bit unsigned varint (also called base-128 varints), as defined by the [multiformats/unsigned-varint](https://github.com/multiformats/unsigned-varint).

> Don't we have to agree on a table of functions?

Yes, but we already have to agree on functions, so this is not hard. The table even leaves some room for custom function codes.

## Implementations

<!-- Note: Please add implementations to this list alphabetically. Thanks! -->

- [clj-multihash](//github.com/multiformats/clj-multihash)
- [cpp-multihash](//github.com/cpp-ipfs/cpp-multihash)
- [dart-multihash](https://github.com/dwyl/dart_multihash)
- elixir-multihash
  - [elixir-multihash](//github.com/zabirauf/ex_multihash)
  - [elixir-multihashing](//github.com/candeira/ex_multihashing)
- [go-multihash](//github.com/multiformats/go-multihash)
- [haskell-multihash](//github.com/LukeHoersten/multihash)
- js-multihash
  - [js-multiformats](//github.com/multiformats/js-multiformats)
  - [js-multihash](//github.com/multiformats/js-multihash) (archived)
- java-multihash
  - [multiformats/java-multihash](//github.com/multiformats/java-multihash)
  - [comodal/hash-overlay](//github.com/comodal/hash-overlay)
- kotlin-multihash
  - [kotlin-multihash](//github.com/changjiashuai/kotlin-multihash)
  - [multiformat](https://github.com/erwin-kok/multiformat)
- net-multihash
  - [cs-multihash](//github.com/multiformats/cs-multihash)
  - [MultiHash.Net](//github.com/MCGPPeters/MultiHash.Net)
  - [net-ipfs-core](//github.com/richardschneider/net-ipfs-core)
- [nim-libp2p](//github.com/status-im/nim-libp2p)
- [ocaml-multihash](//github.com/patricoferris/ocaml-multihash)
- [php-multihash](//github.com/Fil/php-multihash)
- python-multihash
  - [multiformats/py-multihash](//github.com/multiformats/py-multihash)
  - [ivilata/pymultihash](//github.com/ivilata/pymultihash)
  - `multihash` sub-module of Python module [multiformats](//github.com/hashberg-io/multiformats)
- [ruby-multihash](//github.com/neocities/ruby-multihash)
- rust-multihash
  - [by @multiformats](//github.com/multiformats/rust-multihash)
  - [by @google](//github.com/google/rust-multihash)
- [scala-multihash](//github.com/mediachain/scala-multihash)
- swift-multihash
  - [by @multiformats](//github.com/multiformats/SwiftMultihash)
  - [by @yeeth](//github.com/yeeth/Multihash.swift)

## Table for Multihash

We use a single [Multicodec][] table across all of our multiformat projects. The shared namespace reduces the chances of accidentally interpreting a code in the wrong context. Multihash entries are identified with a `multihash` value in the `tag` column.

The current table lives [here](https://github.com/multiformats/multicodec/blob/master/table.csv)

## Prior Art And Translation

In IETF's corpus of normative protocols, there are two partial overlaps worth knowing about to ensure a safe implementation:

* "Named Information Hash", a.k.a. [RFC-6920](https://datatracker.ietf.org/doc/html/rfc6920), defines an hierarchical URI scheme for content-identifiers, partitioned by enumerated hash functions. The [NIH registry][] at IANA contains all of these.
* UUIDv5, aka "Namespaced UUIDs", defined in [RFC-9562](https://datatracker.ietf.org/doc/html/rfc9562#uuidv5), does the inverse, defining a universal namespace for one hash function, partitioned by the application of that function to multiple URI schemes (i.e. DNS names, valid URLs, etc.)
* The IANA [NIH registry][] has a similar shape and governance mode to the IANA [hashAlgorithm registry][] that TLS 1.2 implementations use to compactly signal supported hash+signature combinations. Since the former has different entries for some hash functions based on output length and the latter does not, the two registries are not alignable. However, given their different contexts, collisions between the two would not be a practical concern for users of either.

### Named Information Hash

The "Named Information Hash" URI scheme allows for minimally self-describing hash strings to serve as content-identifiers for arbitrary binary inputs.
This lightweight identifier scheme is defined in [RFC-6920](https://datatracker.ietf.org/doc/html/rfc6920) and the supported hash-context prefixes live in an IANA registry named ["https://www.iana.org/assignments/named-information/named-information.xhtml#hash-alg"](https://www.iana.org/assignments/named-information/named-information.xhtml#hash-alg).
Its syntactic similarity to HTTP headers and [support for](https://datatracker.ietf.org/doc/html/rfc6920#section-3.1), MIME content-types makes it potentially useful for web use-cases, but use-cases are not constrained by URI scheme, only hinted at by the specification in sections 3 through 7.

#### Translation from multihash to named-information hash

Translating from a bare, binary multihash (i.e., a hash value in `unsigned_varint`, a.k.a. ULEB128 format) to a named-information hash in binary format is fairly easy to do insofar as a generic tag for self-describing multihashes was proposed to the [NIH registry][] by [Appendix B](https://www.ietf.org/archive/id/draft-multiformats-multihash-03.html#appendix-D.2) in the 2021 [multihash internet draft](https://www.ietf.org/archive/id/draft-multiformats-multihash-03.html):

1. Strip the prefix bytes from the hash value and use the prefix bytes to identity the hash function used from the [Multicodec][] table
2. If multihash prefix corresponds to any tags in the [NIH registry][]:
  1. translate multicodec tag to NIH tag, i.e., if `0x12` (`sha2-256`) in `multicodec` registry, then `0x01` (`sha256`) in `named-information` registry
  2. transcode the hash value from ULEB128 to standard MSB binary
  3. (for binary form:) reattach new prefix to transcoded hash value
  4. (for ASCII form:) convert prefix to URL format, i.e., `ni:///sha-256;` for `0x01`, and reattach to base64-encoded transcoded hash value
3. If multihash prefix does NOT map cleanly to a registered value in [NIH registry][]:
   1. (for binary form:) prefix existing binary multihash with `0x42` to designate that what follows is a multicodec prefix followed by an ULEB128 hash value.
   2. (for ASCII form:) convert the `0x42` prefix to URL format, i.e., `ni:///mh;` and then append a base64url, no-padding encoding of the entire binary multihash with prefix (and _without_ adding the additional base-64-url-no-padding prefix, `u`, if using a [multibase][] library for this base-encoding).

Note that raw multihashes (i.e. multihashes directly taken from hashing inputs) are not commonly used in IPFS implementations, since inputs are usually broken up into an intermediary form before being hashed.
Only "single-block" CIDs, which are directly produced from inputs without file-system conversion, can be converted as described above; these are usually used for blobs below a certain size, typically using `raw` or `json` or other non-IPLD tags to mark their referents as only one-layer deep.
To translate between CIDs that dereference to an IPLD graph or other recursive structure, you must first reconstruct the inputs and re-encode a new CID using `raw` codec and no chunking structure, indirection, recursion, or outer envelope.

### Namespaced UUIDs

Since the "Named Information Hash" URI scheme conforms to URL syntax (with or without an authority), each valid Named Information Hash URI can be assumed to be unique within the namespace of all valid URLs.
As such, any `ni://` URL (with or without an authority) can be hashed and used as a [UUIDv5](https://datatracker.ietf.org/doc/html/rfc9562#uuidv5) in the URL namespace, i.e. `6ba7b811-9dad-11d1-80b4-00c04fd430c8` (See [section 6.6](https://datatracker.ietf.org/doc/html/rfc9562#namespaces)).

Since this approach relies on SHA-1, and discards all but the most significant 128 bits of the hash output, its security may not be adequate for all applications, as noted in the specification.
Alternative ways of using a bounded namespace could include a novel namespace registration for UUIDv5, or a UUIDv8 approach, to content-address arbitrary information with namespaced UUID variants.

## Notes

### Multihash and randomness

**Obviously multihash values bias the first two bytes**. Do not expect them to be uniformly distributed. The entropy size is `len(multihash) - 2`. Skip the first two bytes when using them with bloom filters, etc. Why not _ap_pend instead of _pre_pend? Because when reading a stream of hashes, you can know the length of the whole value, and allocate the right amount of memory, skip it, or discard it.

### Insecure / obsolete hash functions

**Obsolete and deprecated hash functions are included** in this list. [MD4](https://en.wikipedia.org/wiki/MD4), [MD5](https://en.wikipedia.org/wiki/MD5) and [SHA-1](https://en.wikipedia.org/wiki/SHA-1) should no longer be used for cryptographic purposes, but since many such hashes already exist they are included in this specification and may be implemented in multihash libraries.

MD5 and SHA-1 were previously used in TLS and DTLS protocols version 1.2, as defined in [RFC5246](https://www.rfc-editor.org/rfc/rfc5246#section-1.2), but were later deprecated by [RFC9155](https://www.rfc-editor.org/rfc/rfc9155.html).
MD4 seems to have gone out of favor even before TLS 1.2 was finalized at IETF, and was officially deprecated by [RFC-6150](https://www.rfc-editor.org/rfc/rfc6150).

### Non-cryptographic hash functions

Multihash is intended for *"well-established cryptographic hash functions"* as **non-cryptographic hash functions are not suitable for content addressing systems**. However, there may be use-cases where it is desireable to identify non-cryptographic hash functions or their digests by use of a multihash. Non-cryptographic hash functions are identified in the [Multicodec table](https://github.com/multiformats/multicodec/blob/master/table.csv) with a tag `hash` value in the `tag` column.

## Visual Examples

These are visual aids that help tell the story of why Multihash matters.

![](https://raw.githubusercontent.com/multiformats/multihash/master/img/multihash.001.jpg)

#### Consider these 4 different hashes of same input

![](https://raw.githubusercontent.com/multiformats/multihash/master/img/multihash.002.jpg)

#### Same length: 256 bits

![](https://raw.githubusercontent.com/multiformats/multihash/master/img/multihash.003.jpg)

#### Different hash functions

![](https://raw.githubusercontent.com/multiformats/multihash/master/img/multihash.004.jpg)

#### Idea: self-describe the values to distinguish

![](https://raw.githubusercontent.com/multiformats/multihash/master/img/multihash.005.jpg)

#### Multihash: fn code + length prefix

![](https://raw.githubusercontent.com/multiformats/multihash/master/img/multihash.006.jpg)

#### Multihash: a pretty good multiformat

![](https://raw.githubusercontent.com/multiformats/multihash/master/img/multihash.007.jpg)

#### Multihash: has a bunch of implementations already

![](https://raw.githubusercontent.com/multiformats/multihash/master/img/multihash.008.jpg)

## Contribute

Contributions welcome. Please check out [the issues](https://github.com/multiformats/multihash/issues).

Check out our [contributing document](https://github.com/multiformats/multiformats/blob/master/contributing.md) for more information on how we work, and about contributing in general. Please be aware that all interactions related to multiformats are subject to the IPFS [Code of Conduct](https://github.com/ipfs/community/blob/master/code-of-conduct.md).

Small note: If editing the README, please conform to the [standard-readme](https://github.com/RichardLitt/standard-readme) specification.

## References

The [Prior Art and Translation](#prior-art-and-translation) section is heavily indebted to an earlier 2024 blog post, ["The Secret of NIMHs: Naming Things with Multihashes](https://bengo.is/blogging/the-secret-of-nimhs/), by github user @gobengo .

[multicodec]: https://github.com/multiformats/multicodec
[NIH registry]: https://www.iana.org/assignments/named-information/named-information.xhtml#hash-alg
[hashAlgorith registry]: https://www.iana.org/assignments/tls-parameters/tls-parameters.xhtml#tls-parameters-18

## License

This repository is only for documents. All of these are licensed under the [CC-BY-SA 3.0](https://ipfs.io/ipfs/QmVreNvKsQmQZ83T86cWSjPu2vR3yZHGPm5jnxFuunEB9u) license © 2016 Protocol Labs Inc. Any code is under a [MIT](LICENSE) © 2016 Protocol Labs Inc.
