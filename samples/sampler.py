
# todo select a sample of 100 items from directory
# specify envi]

import os
import sys
import random

# get sample_path
assert isinstance(sys.argv[1], str)
assert isinstance(sys.argv[2], str)

n = int(sys.argv[2].strip())
var = sys.argv[1].strip()
fls = os.listdir(os.environ[var])

samples = random.sample(fls, n)

assert(len(samples) == n)

print(samples[:5])