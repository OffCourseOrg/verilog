#!/usr/bin/python

import random


with open("TARGET.template", 'r', encoding='UTF-8') as source:
    with open("TARGET.v", 'w', encoding='UTF-8') as target:
      while line := source.readline():
          line = line.replace("_RANDOM_DIGIT_", f"{random.randrange(0, 10)}")
          target.write(line)