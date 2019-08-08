#!/usr/bin/env python2

import os
import sys
import random

def usage(code):
  print "usage:", sys.argv[0], "<number> <size>"
  print "output <number> random hex-encoded strings of <size> bytes"
  sys.exit(code)

hexcode = '0123456789abcdef'
def randstr(length):
   return ''.join(random.choice(hexcode) for i in range(length))

def gen_strings(num, length):
  for i in range(0, num):
    yield randstr(length)

def main():
  if '-h' in sys.argv or '--help' in sys.argv:
    usage(0)
  if len(sys.argv) != 3:
    usage(1)

  num = int(sys.argv[1])
  length = int(sys.argv[2])
  if not (num > 0 and length > 0):
    usage(1)

  for s in gen_strings(num, length):
    print s

if __name__ == "__main__":
  main()
