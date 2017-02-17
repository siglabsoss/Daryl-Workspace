import os, time
import numpy as np
import matplotlib.pyplot as pt
import jinja2

env = jinja2.Environment(loader=jinja2.FileSystemLoader('templates'))
temp = env.get_template('dds.svt')

def mybin(x, N=36):
    if x < 0:
        return '{:036b}'.format(2**N + x)
    else:
        return '{:036b}'.format(x)

lut_width = 16;

sin_values = [ mybin(int(sk)) for sk in np.round((2**35-1)*np.sin(2*np.pi*np.arange(2.0**lut_width)*2.0**-lut_width))]
cos_values = [ mybin(int(ck)) for ck in np.round((2**35-1)*np.cos(2*np.pi*np.arange(2.0**lut_width)*2.0**-lut_width))]

#os.system('rm -f dds.sv')
os.system('del /Q dds.sv')
with open('dds.sv', 'w') as fid:
    print(
        temp.render(
            romname='dds',
            date=time.strftime("%m/%d/%Y"),
            lut_width=lut_width,
            lut_values=np.arange(2**lut_width),
            sin_values=sin_values,
            cos_values=cos_values
        ),
        file=fid)