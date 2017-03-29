import os, time
import numpy as np
import matplotlib.pyplot as pt
import jinja2

env = jinja2.Environment(loader=jinja2.FileSystemLoader('templates'))
temp = env.get_template('dds.svt')

def mybin(x, N=36):
    if N == 32:
        if x < 0:
            return '{:036b}'.format(2**N + x)
        else:
            return '{:036b}'.format(x)
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

lut_width = 12;

sin_values = [ mybin(int(sk)) for sk in np.round((2**35-1)*np.sin(2*np.pi*np.arange(2.0**lut_width)*2.0**-lut_width)) ]
cos_values = [ mybin(int(ck)) for ck in np.round((2**35-1)*np.cos(2*np.pi*np.arange(2.0**lut_width)*2.0**-lut_width)) ]

#os.system('rm -f dds.sv')
os.system('del /Q dds.sv')
with open('chmod_dds.sv', 'w') as fid:
    print(
        temp.render(
            romname='chmod_dds',
            date=time.strftime("%m/%d/%Y"),
            lut_width=lut_width,
            lut_values=np.arange(2**lut_width),
            sin_values=sin_values,
            cos_values=cos_values,
            two_pi=mybin(int((2**15)*2*np.pi), N=18)
        ),
        file=fid)