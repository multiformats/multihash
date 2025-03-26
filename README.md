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
  - [Other Tables](#other-tables)
- [Notes](#notes)
  - [Multihash and randomness](#multihash-and-randomness)
  - [Insecure / obsolete hash functions](#insecure--obsolete-hash-functions)
  - [Non-cryptographic hash functions](#non-cryptographic-hash-functions)
- [Visual Examples](#visual-examples)
- [Maintainers](#maintainers)
- [Contribute](#contribute)
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
  - [copper multicodec and multihash](https://github.com/filip26/copper-multicodec)
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
  - [by @ATProtoKit](https://github.com/ATProtoKit/MultiformatsKit)
- [zig-multihash](https://github.com/zen-eth/multiformats-zig)

## Table for Multihash

We use a single [Multicodec](https://github.com/multiformats/multicodec) [table](https://github.com/multiformats/multicodec/blob/master/table.csv) across all of our multiformat projects. The shared namespace reduces the chances of accidentally interpreting a code in the wrong context. Multihash entries are identified with a `multihash` value in the `tag` column.

### Other Tables

Cannot find a good standard on this. Found some _different_ IANA ones:

- https://www.iana.org/assignments/tls-parameters/tls-parameters.xhtml#tls-parameters-18
- http://tools.ietf.org/html/rfc6920#section-9.4

They disagree. :(

## Notes

### Multihash and randomness

**Obviously multihash values bias the first two bytes**. Do not expect them to be uniformly distributed. The entropy size is `len(multihash) - 2`. Skip the first two bytes when using them with bloom filters, etc. Why not _ap_pend instead of _pre_pend? Because when reading a stream of hashes, you can know the length of the whole value, and allocate the right amount of memory, skip it, or discard it.

### Insecure / obsolete hash functions

**Obsolete and deprecated hash functions are included** in this list. [MD4](https://en.wikipedia.org/wiki/MD4), [MD5](https://en.wikipedia.org/wiki/MD5) and [SHA-1](https://en.wikipedia.org/wiki/SHA-1) should no longer be used for cryptographic purposes, but since many such hashes already exist they are included in this specification and may be implemented in multihash libraries.

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

## License

This repository is only for documents. All of these are licensed under the [CC-BY-SA 3.0](https://ipfs.io/ipfs/QmVreNvKsQmQZ83T86cWSjPu2vR3yZHGPm5jnxFuunEB9u) license © 2016 Protocol Labs Inc. Any code is under a [MIT](LICENSE) © 2016 Protocol Labs Inc.
