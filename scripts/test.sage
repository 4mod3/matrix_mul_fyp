import numpy as np
from numpy.random import default_rng
import sys
args = sys.argv
seed = int(args[1])
M = int(args[2])
N = int(args[3])
K = int(args[4])

rng = default_rng(seed)
A = rng.random(size=(M, N), dtype=np.float64)
B = rng.random(size=(N, K), dtype=np.float64)
res_data = np.genfromtxt("./src/sim/build/C_res_{:d}_{:d}_{:d}_{:d}.out".format(M,N,K,seed), comments="//", dtype = str).reshape(M,K)
str2num = np.vectorize(lambda x: int("0x"+x, int(16)))
res_num = str2num(res_data)
res_num.dtype = np.float64

R100 = RealField(100)

C_precise = matrix(R100, M, K, 0)
A_m = matrix(R100, A)
B_m = matrix(R100, B)
C_precise = A_m * B_m
C = np.matmul(A, B)

C_sep = matrix(R100, C)
C_res = matrix(R100, res_num)
# print(C_res)
# print("----------------------")
# print(C_sep)
print("FP64:   ", sum(sum((C_precise - C_sep).apply_map(lambda x: abs(x)))))
print("Design: ", sum(sum((C_precise - C_res).apply_map(lambda x: abs(x)))))
# print((C_sep - C_res))


