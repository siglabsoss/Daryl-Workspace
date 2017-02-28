import os, time
import numpy as np
import matplotlib.pyplot as pt
import jinja2

env = jinja2.Environment(loader=jinja2.FileSystemLoader('templates'))
temp = env.get_template('fixed_ddsx2.svt')
temp2 = env.get_template('sincos.svt')

def mybin(x, N=36):
    if N == 36:
        if x < 0:
            return '{:036b}'.format(2**N + x)
        else:
            return '{:036b}'.format(x)
    elif N == 32:
        if x < 0:
            return '{:032b}'.format(2**N + x)
        else:
            return '{:032b}'.format(x)
    elif N == 18:
        if x < 0:
            return '{:018b}'.format(2**N + x)
        else:
            return '{:018b}'.format(x)
    elif N == 16:
        if x < 0:
            return '{:016b}'.format(2**N + x)
        else:
            return '{:016b}'.format(x)
    elif N == 8:
        if x < 0:
            return '{:08b}'.format(2**N + x)
        else:
            return '{:08b}'.format(x)
    else:
        if x < 0:
            return '{:0b}'.format(2**N + x)
        else:
            return '{:0b}'.format(x)

# This is the number of samples in one period of the carrier wave
period = 500 * 63 # 31500
# This is the number of samples needed in the table
tb_period = int(period / 2)
# lut_width must be smallest power of 2 greater than the period
lut_width = int(np.ceil(np.log2(tb_period)))
# Width of each sine or cosine entry in table
lut_value_width = 36

if 2**lut_width < tb_period:
    print("Warning: Table is too small to contain one period of the carrier!")

Fs = 250.0
Fc = 31.5

sin_values = [ mybin(int(sk), N=lut_value_width)
    for sk in np.round((2**(lut_value_width-1)-1)*np.sin(2*np.pi*np.arange(2.0**lut_width)*Fc/Fs))
]

cos_values = [ mybin(int(ck), N=lut_value_width)
    for ck in np.round((2**(lut_value_width-1)-1)*np.cos(2*np.pi*np.arange(2.0**lut_width)*Fc/Fs))
]

#os.system('rm -f fixed_ddsx2.sv')
os.system('del /Q fixed_ddsx2.sv')
with open('fixed_ddsx2.sv', 'w') as fid:
    print(
        temp.render(
            romname='ddsx2',
            date=time.strftime("%m/%d/%Y"),
            lut_width=lut_width,
            lut_period=tb_period,
            lut_value_width=lut_value_width
        ),
        file=fid)

sincos = []
for sin_value, cos_value in zip(sin_values, cos_values):
    sincos.append('' + sin_value + cos_value)

#os.system('rm -f sincos.mif')
os.system('del /Q sincos.mif')
with open('sincos.mif', 'w') as fid:
    print(
        temp2.render(
            romname='sincos',
            date=time.strftime("%m/%d/%Y"),
            sincos=sincos
        ),
        file=fid)
