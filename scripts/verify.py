import numpy as np

def IEEE_floating_mul(a, b):
    buffer_ = np.array([a,b], dtype=np.uint64)
    print("multiply: {:016X}".format(buffer_[0]), '  |  ', "{:016X}".format(buffer_[1]))    
    buffer_.dtype = np.float64
    print(buffer_[0])
    buffer_[0] = buffer_[0] * buffer_[1]
    buffer_.dtype = np.uint64
    return buffer_[0]

def IEEE_floating_add(a, b):
    buffer_ = np.array([a,b], dtype=np.uint64)
    print("add: ", "{:016X}".format(buffer_[0]), '  |  ', "{:016X}".format(buffer_[1]))
    buffer_.dtype = np.float64
    buffer_[0] = buffer_[0] + buffer_[1]
    buffer_.dtype = np.uint64
    return buffer_[0]

def fpn2IEEE754(num):
    buffer_ = np.array([num], dtype=np.float64)
    buffer_.dtype = np.uint64
    return buffer_[0]

mul_res_alpha = IEEE_floating_mul(0x3FE428785C24BE49, 0x3FD6D0ACE97DEEB8)
mul_res_beta = IEEE_floating_mul(0x3FE9CA9149367F4D, 0x3FEDAD51FCAE0917)
print("mul_res_alpha: {:016X}".format(mul_res_alpha))
print("mul_res_beta: {:016X}".format(mul_res_beta))

print( "add_res: {:016X}".format(IEEE_floating_add(mul_res_alpha, 0x400CAAAF0718227B)))
print("{:016X}".format(fpn2IEEE754(3.8079068540181082)))

# --------------------------------
# 0x3FC7997ED8A0A6C4 x 0x3FD69C1D9F1BDE80 + 0x3FE7EE6B344E123F
# FP64: 0x3FEA04005F462880
# design: 3FEA04005F46287F
# R100: 0.1-1010000001000000000001011111010001100010100001111111-01111111101101000000000011110011100111010101101

# 0.1 1010000001000000000001011111010001100010100001111111 01111111101101000000000011110011100111010101101
# 111001.0101000000010111000100011100001000101111110101110000000101110110101111000101010011100111011100

# --------------------------------
# 0x3FE428785C24BE49 x 0x3FD6D0ACE97DEEB8 + 0x400CAAAF0718227B
# FP64: 0x400E7697DE61C6B4
# design: 0x400E7697DE61C6B3
# R100: -11110011101101001011111011110011000011100011010110011-01010000100101000101100110111101111101011010001

# --------------------------------
# float64 to R100 (bits)
# 0011111111100101110101011101001110010011001000000111111001111101
#   1111111110010111010101110100111001001100100000011111100111110100000000000000000000000000000000000000

# --------------------------------
# row 0 过程结果
# 0 : 3FE19946355DCCF5
# 1 : 3FE1BBCB095B11DA
# 2 : 3FE7EE6B344E123F 
# 3 : 3FEA04005F462880 <=== Different
# 4 : 3FECF79AE0DB4583
# 5 : 3FF549D363A8DD3D
# 6 : 40006E7EF6F1A5FD
# 7 : 400211A017A7FEFB
# 8 : 4002B19771A667F0
# 9 : 400547C258900AAE
# 10 : 4007D54EA0F0AB31
# 11 : 40092FFA6454BE84
# 12 : 400AFE9128DBDEA9
# 13 : 400B44C452AC5FB5
# 14 : 400CAAAF0718227C
# 15 : 400E7697DE61C6B4
