#!/usr/bin/env python2

import os
import sys
import subprocess

# modify these to add more test cases
algs = ['sha1', 'sha2-256', 'sha2-512', 'sha3']
sizes = [80, 160, 256, 512]

def die(arg):
  print "error:", arg
  sys.exit(1)

def require(tool):
  if os.system("which " + tool + ">/dev/null") is not 0:
    die("requires %s tool" % tool)

def usage(code):
  print "usage:", sys.argv[0], "<input_strings >test_cases"
  print "output multihash test cases for every string in stdin"
  sys.exit(code)

def multihash(val, alg, size):
  cmd = "multihash -a %s -l %d -e hex -q" %  (alg, size)
  proc = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE, stdin=subprocess.PIPE)
  (out, err) = proc.communicate(val)

  # failed to process multihash
  if proc.returncode != 0:
    raise ValueError("multihash failed")

  # incorrect length (truncated shorter than desired length)
  shdbe = ((size / 8) + 2) * 2
  if shdbe != len(out):
    raise ValueError("incorrect multihash length: %s %s" % (len(out), shdbe))

  return out

def produce(val, alg, size):
  m = multihash(val, alg, size)
  return "%s,%s,%s,%s" % (alg, size, val, m)

def gen_testcases(strings):
  for l in strings:
    l = l.strip()
    for a in algs:
      for s in sizes:
        try:
          yield produce(l, a, s)
        except ValueError, e:
          pass

def main():
  if '-h' in sys.argv or '--help' in sys.argv:
    usage(0)
  if len(sys.argv) != 1:
    usage(1)

  require("multihash")
  print "algorithm,bits,input,multihash"
  for t in gen_testcases(sys.stdin):
    print t

if __name__ == "__main__":
  main()
