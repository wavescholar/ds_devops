#!/usr/bin/env python

import os
os.system('pip install ksvd')
os.system('git clone https://github.com/nel215/image-noise-reduction.git')

import numpy as np
from ksvd import ApproximateKSVD


# X ~ gamma.dot(dictionary)
X = np.random.randn(1000, 20)
aksvd = ApproximateKSVD(n_components=128)
dictionary = aksvd.fit(X).components_
gamma = aksvd.transform(X)

os.chdir('image-noise-reduction')

#os.system('pip install -r requirements.txt')

#See makefile for steps
os.system('make result.txt')
