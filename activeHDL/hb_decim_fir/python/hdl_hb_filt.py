import os, time
import numpy as np
import matplotlib.pyplot as pt
import jinja2

h = [  -122, 0,   187, 0,   -323, 0,    517, 0,   -785, 0,   1146, 0,  -1622, 0,  2243,      0,
      -3051, 0,  4112, 0,  -5533, 0,   7520, 0, -10511, 0,  15656, 0, -27184, 0, 83231, 131072,
      83231, 0,-27184, 0,  15656, 0, -10511, 0,   7520, 0,  -5533, 0,   4112, 0, -3051,      0,
       2243, 0, -1622, 0,   1146, 0,   -785, 0,    517, 0,   -323, 0,    187, 0,  -122 ]
h = np.array(h)

env = jinja2.Environment(loader=jinja2.FileSystemLoader('templates'))
temp = env.get_template('hb_decim_filt.svt')

def mybin(x, N=18):
    if x < 0:
        return '{:018b}'.format(2**N + x)
    else:
        return '{:018b}'.format(x)

hb = [ mybin(hk) for hk in h ]

#os.system('rm -f hb_decim_filt.sv')
os.system('del /Q hb_decim_filt.sv')
with open('hb_decim_filt.sv', 'w') as fid:
    print(
        temp.render(
            romname='ldpc_column_to_row',
            date=time.strftime("%m/%d/%Y"),
            delay_range=(np.arange(32), np.arange(16)),
            max_delay=32,
            coeffs=hb[::2],
            adder_tree_range=np.arange(1, 4)
        ),
        file=fid)