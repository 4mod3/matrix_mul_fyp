import numpy as np

res_data = np.genfromtxt("./src/sim/C_res.out", comments="//", dtype = str).reshape()
print(res_data)

str2num = np.vectorize(lambda x: int("0x"+x, 16))
res_num = str2num(res_data)
# res_num.dtype = np.float64
print("{:016X}".format(res_num[0]))