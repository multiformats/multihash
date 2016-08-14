# The Multihash Format

## Introduction

TODO

### Hash Functions

TODO

### Self Description

TODO (use a definition from multiformats + example for hashes)

### Example Use Cases

TODO

### Terminology

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT",
"SHOULD", "SHOULD NOT", "RECOMMENDED", "MAY", and "OPTIONAL" in this
document are to be interpreted as described in RFC 2119, BCP 14
[RFC2119] and indicate requirement levels for compliant multihash
implementations.

This specification makes use of the following terminology:

Varint: A variable sized unsigned integer, represented with a Most
  Significant Bit (MSB) Varint with no size limit.

Hash function: TODO

Cryptographic hash function: TODO

Digest: The output value of a hash function.

Length-prefixed: A variable sized byte sequence, prefixed with the
  length of the sequence. Example: "0x03aabbcc" is the sequence
  "0xaabbcc" prefixed with the length: "0x03". For our purposes,
  these prefixes are varints.

## Multihash Function Tables

A Multihash Function Table assigns a unique integer code and a
unique string name to each hash function listed on the table.
You can think of these tables as a list of triples, where each
the integer code MUST be unique, the string name MUST be unique,
and the function should be a well defined hash function:

  # a multihash table is a list of triples:
  <code> <name> <function>
  ...

  # example multihash table:
  0x01 identity "The Identity Hash Function"
  0x11 sha1     "The SHA1 Cryptographic Hash Function"
  0x12 sha2-256 "The SHA256 Cryptographic Hash Function"
  0x13 sha2-512 "The SHA512 Cryptographic Hash Function"
  0x14 sha3-512 "The SHA3-512 Cryptographic Hash Function"
  ...

`<code>`: a unique (unsigned) integer code for a compact
  representation of the hash function. Usually represented
  as a varint. The table has no length limit.

`<name>`: a unique string name for a more human readable
  representation of the hash function. It is restricted to
  the following ASCII character values: `[a-zA-Z0-9]+`. In
  most cases, this name SHOULD be enough for a programmer
  to know without ambiguity precisely which hash function is
  intended.

`<function>`: is a unique string name or definition of the
  hash function. For most purposes, this MUST be enough of a
  definition to allow a programmer to know, without any ambiguity,
  precisely which hash function is intended. A self-describing
  multihash table may opt to represent functions as the code
  itself.

TODO: possibly remove `<hash-function>` entirely, and rely solely
on the `<string-code>`? Is there such a table already to rely on?
Such a table must include both cryptographic and non-cryptographic
hash functions.

### Standard Multihash Table

There is a Standard Multihash Table that all implementations
MUST support. This table exists to provide agreement on the
int and string codes of widely known hash functions.

What level of notoriety must a hash function achieve before
being included in the Standard Multihash Table? This question
is left up to the maintainers of the table, presumably IANA.

The current value of the Standard Multihash Table is:

  # 0x10-0x3f reserved for SHA standard functions
  # 0x60-0x7f reserved for custom hash functions
  # 0x3000-0x3fff reserved for custom hash functions
  # code, name
  0x00, identity
  0x11, sha1
  0x12, sha2-256
  0x13, sha2-512
  0x14, sha3-512
  0x15, sha3-384
  0x16, sha3-256
  0x17, sha3-224
  0x18, shake-128
  0x19, shake-256
  0x40, blake2b
  0x41, blake2s

TODO: either add the `<function>` part or NOT.

The Standard Multihash Table reserves some ranges for growth,
and for custom tables:

0x01-0x3f: reserved for SHA standard functions.

A fourth of all integers is reserved for custom tables. That
way, neither the numbers for the standard table nor for custom
tables can run out. The reserved numbers are at the upper
fourth of every varint range. This means the following ranges,
and the series they imply:

  0d96    to 0d127   or 0b1100000        to 0b1111111
  0d12288 to 0d16383 or 0b11000000000000 to 0b11111111111111

Put another way: every varint byte contributes 7 bits to the
number. We say that all numbers whose 7-bit representation
starts with 0b11..., are reserved for custom tables. This
is a fourth of all numbers, and yields the sequence above.

TODO: check if the above makes sense readily, or we want a
better explanation or a better range.

### Custom Tables

Uses MAY create custom multihash tables to use custom hash
functions not defined in the Standard Multihash Table. In
order to avoid any ambiguity whatsoever, these custom tables
MUST be strict super-sets of the Standard Multihash Table.
Therefore, they MUST define any custom functions with the
integer codes reserved for this purpose, and must use string
names that begin with `x-`.

  # example custom table. superset of SMT
  # 0x01-0x0f reserved for application specific functions
  # 0x10-0x3f reserved for SHA standard functions
  0x00, identity
  0x11, sha1
  0x12, sha2-256
  0x13, sha2-512
  0x14, sha3-512
  0x15, sha3-384
  0x16, sha3-256
  0x17, sha3-224
  0x18, shake-128
  0x19, shake-256
  0x40, blake2b
  0x41, blake2s

### Self-Describing Multihash Tables

It is possible to define a multihash table using completely
self-describing definitions, meaning that the hash function
itself is stored not by name but as a code value. How to do
that is left up to future specifications. If one is defined,
this specification SHOULD be updated to link to it.

## Specification of the multihash format

Multihash is a self-describing format to store, transmit, and
display hash function digest values. It is unambiguous, provides
"algorithmic agility", prevents "algorithm lock-in", improves the
security of hash value transmissions, and improves the usability
of hash functions.

The multihash format is very simple. It defines a single value
type: a multihash value. A multihash value consists of three parts:

1. Hash Function Code: an integer code representing a hash
  function from a pre-determined hash function table, expressed
  as a varint.
2. Digest Length: the length of the hash function digest value,
  expressed as a varint.
3. Digest Value: the hash function digest value, conforming to
  the Digest Length

These three parts are laid out in a byte sequence as follows:

    <hash-function-code><digest-length><digest-value>

The multihash format defines two representations for a multihash
value:

1. Packed Representation: a compact representation for use
  on the wire, in storage, in displays, and in other identifiers.
2. Explanation Representation: a larger, human readable
  representation to make distinguishing values easier on
  developers.

Both representations follow the same parts order as above, only
changing each of the parts.

For all intents and purposes, the Packed Representation is the
main contribution of this specification. The Explanation
Representation is merely here to provide a single standard way to
dump out values in more readable forms.

### Packed Representation

The Packed Representation is a compact representation optimized
for transmitting, storing, displaying, and using multihashes.
It is optimized to avoid wasting space. It is also tuned to be
incorporated into other values, such as content-addressed store
identifiers, URI/URLs, unix filesystem paths, and more. This is
the primary representation of a multihash format.

The Packed Representation is structured as follows:

    <hash-function-code-v><digest-length-v><digest-value-bin>

Where:
- `<hash-function-code-v>` is a varint storing the code of the hash function
  according to a pre-determined multihash table, and the Standard Multihash
  Table.
- `<digest-length-v>` is a varint storing the length of `<digest-value>`,
  in bytes.
- `<digest-value-bin>` is the hash function digest value, binary-packed.

#### Hash Function Code

The Hash Function Code in the packed representation is an unsigned
varint, following the format specified in section (TODO). This code
references a pre-determined multihash table, usually the standard
Standard Multihash Table maintained alongside this specification.

It is possible for users to define and use their own tables, which
MUST be compatible with the Standard Multihash Table, by using
only the code ranges left undefined for this purpose. Section (TODO)
explains the Standard Multihash Table and which ranges can be used.

#### Digest Length in Bytes

The `<digest-length>` counts bytes, not bits. This reduces the storage
required for most hash function values: 256 and 512 bit lengths are
represented as "32" and "64", using 1-byte varints instead of 2-byte
varints.

This size reduction exploits the facts that: (a) most common computer
architectures use 8-bit words, (b) most networks transit sequences of
bytes, (c) most storage systems store sequences of bytes, and (d) most
if not all widely used hash functions have standard digest lengths
divisible by 8.

It is possible that some hash functions are used with digests of lengths
not evenly divisble by 8. In such rare cases, the function implementation
with multihash should define a byte-aligned version, usually by adding a
pre-determined amount of padding bits at the end of the value. Such
padding transformations can be well-defined, and would likely have to
exist to support such hash functions in current computer architectures,
storage systems, and networks. Therefore this specification is comfortable
leaving this up to the implementations and users.

#### Digest Value

The `<digest-value-bin>` is simply a binary-packed representation of the
hash function value. This value ensures the entire Multihash Packed
Representation is as compact as it could be, wasting no space to
represent the digest value.

Base encoding for strings must be performed around the whole multihash
value,

### Explanation Representation

The Explanation Representation is a well defined way of representing
the hash functions in a human-readable optimized way. It is wasteful
explicitly, and not meant to be used as an identifier in systems.

The Explanation Representation is

    <hash-function-name>.<digest-length>.<digest-value-hex>

Where:
- `<hash-function-name>` is the string name of the code of the hash
  function according to a pre-determined multihash table, and the
  Standard Multihash Table.
- `<digest-lengt>` is a decimal number storing the length of
  `<digest-value>`, in bytes.
- `<digest-value-hex>` is the hash function digest value, hex-encoded.
- `.` is a delimiter for the values.

This representation SHOULD NOT be used to transmit, store, or embed a
multihash value. It SHOULD only be used for debugging.

Even when creating human-oriented string identifiers, it is strongly
RECOMMENDED to use the packed representation of multihash, possibly
encoded in a convenient base. This ensures the whole multihash value
is as compact as it can be, and does not accidentally impose other
requirements on the transmission of the value. It is much easier for
systems to deal with a binary value that can be easily encoded in a
variety of bases. Using the Explanation Representation for storage,
transmission, embedding in other identifiers, or anything other
than debugging, defeats the purpose of multihash.

### MSB Unsigned Varints - muvints

Multihash uses muvints, Most-significant-bit Unsigned Variable
INTegerS. These are in use by other multiformats. Their definition
is summarized here for completeness.

Unsigned: muvints are unsigned integers. There is no need for
  distinguishing negative integers.

Varints: muvints are variable integers, with no limit.

MSB continuation: muvints use the Most Significant Bit of every byte
  to represent a continuation bit. This type of varint is optimized
  for space and reads of small numbers, not for reads of very large
  numbers (128-bit ints and beyond).

Little-Endian: muvints are based on Protocol Buffers varints, and
  are thus little-endian, meaning the least significant bytes are
  encoded first.

Examples:

  # decimal   muvint bytes
  127         01111111
  128         10000000 00000001
  256         10000000 00000010
  1024        10000000 00001000
  16384       10000000 10000000 00000001

## Encoding multihashes

Multihashes are designed to be used as values in a variety of
mediums. They will often need to be encoded in other bases.
In particular, multihash endeavors to keep the function code
and length in the same base encoding as the digest value, which
is important to many applications that must treat hash digest
values opaquely, or that may have base encoding restrictions.

Binary: It is RECOMMENDED that multihash values are stored
  and transmitted on the wire as binary packed values wherever
  possible. This will ensure the hash digests take up as little
  space as possible.

Copiable: It is RECOMMENDED that multihash values are displayed
  to users in a "copiable" form, that is in a form easy to select,
  copy, and paste, which typically means in base16, base32, base58.

Multibase: Multihash pairs well with Multibase, a standard for
  self-describing base encodings. This way, a multihash value can
  be stored, transmitted, or displayed in any base without any
  ambiguity.


## Considerations

### Implementation considerations

TODO

### IANA considerations

It is RECOMMENDED that IANA host the Standard Multihash Table.

### Security considerations

It is RECOMMENDED that implementations establish a reasonable
upper bound on varint sizes to avoid allocating large buffers,
or potential buffer overflows. This limit will make sense at given
times, depending on the size of the tables and common sizes for
the digests of commonly used hash functions. Such a limit is
explicitly left out of this specification as it is liable to be
an incorrect choice as time passes.

## Acknowledgements

Special thanks to the following people for helping to define,
implement, review, and extend multihash:

TODO list contributors


## References

TODO
