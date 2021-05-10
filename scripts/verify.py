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

mul_res_alpha = IEEE_floating_mul(0x3FAB8E6DB72F96D0, 0x3FB40AE94FE4BBE8)
mul_res_beta = IEEE_floating_mul(0x3FE9CA9149367F4D, 0x3FE5D5D393207E7D)
print("mul_res_alpha: {:016X}".format(mul_res_alpha))
print("mul_res_beta: {:016X}".format(mul_res_beta))

print( "add_res: {:016X}".format(IEEE_floating_add(mul_res_alpha, 0x3FE19946355DCCF5)))
print("{:016X}".format(fpn2IEEE754(0.55417396380704107639501182206)))