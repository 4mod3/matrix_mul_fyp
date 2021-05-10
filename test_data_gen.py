#! /usr/bin/env python
# -*- coding: utf-8 -*-
# vim:fenc=utf-8
#
# Copyright © 2021 gins <gins@ginsSlim7>
#
# Distributed under terms of the MIT license.

"""
generate 16x16 floating-points matrix example (IEEE-754). 
"""

import numpy as np
import math
from numpy.random import default_rng

# import struct
# def double2bin(num):
#     bits, = struct.unpack('!I2', struct.pack('!d', num))
#     return "{:064b}".format(bits)

#----------------------------------------------------------------------
# random examples for all bits
# A = rng.integers(low = (1<<52), high = (1<<63)-1-(1<<52), dtype = np.uint64, size = (3,3), endpoint = True)
# A.dtype = np.double
# print(A)

#----------------------------------------------------------------------
# random examples in [0.0, 1.0]
mat_size = 16
rng = default_rng(123)
A = rng.random(size=(mat_size, mat_size), dtype=np.float64)
B = rng.random(size=(mat_size, mat_size), dtype=np.float64)
C = A @ B
A.dtype = np.uint64
B.dtype = np.uint64
C.dtype = np.uint64
# C_arr = np.ndarray(shape=(1,), dtype='<u8', buffer=C[0,0])
# print('{:064b}'.format(C_arr[0]))
# big-endian
print('{:064b}'.format(C[0,0]))
# 0100000000001110011101101001011111011110011000011100011010110100
# 0100000000001110011101101001011111011110011000011100011010110100
format2str = np.vectorize(lambda num: '{:064b}'.format(num))
A_str = format2str(A)
B_str = format2str(B)
C_str = format2str(C)
# np.array([A, B]).tofile('./src/sim/AB.out', sep='\n', format='%016X')
T = np.arange(1, mat_size*2*mat_size+1, dtype=np.uint64).reshape(mat_size*2, mat_size)
T.tofile('./src/sim/AB.out', sep='\n', format='%016X')
C.tofile('./src/sim/C.out', sep='\n', format='%016X')

