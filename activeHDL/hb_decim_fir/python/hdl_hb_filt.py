import os, time
import numpy as np
import matplotlib.pyplot as pt
import jinja2

h = np.array([
     -122,      0,   187,  0,  -323,  0,    517, 0,   -785, 0,
     1146,      0,  -1622, 0,  2243,  0,  -3051, 0,   4112, 0,
    -5533,      0,   7520, 0, -10511, 0,  15656, 0, -27184, 0,
    83231, 131072,  83231, 0, -27184, 0,  15656, 0, -10511, 0,
     7520,      0,  -5533, 0,   4112, 0,  -3051, 0,   2243, 0,
    -1622,      0,   1146, 0,   -785, 0,    517, 0,   -323, 0,
      187,      0,  -122
])

env = jinja2.Environment(loader=jinja2.FileSystemLoader('templates'))
temp = env.get_template('hb_decim_filt.svt')
temp2 = env.get_template('hb_decim_filtx2.svt')

def mybin(x, N=18):
    if x < 0:
        return '{:018b}'.format(2**N + x)
    else:
        return '{:018b}'.format(x)

hb = [ mybin(hk) for hk in h ]

#os.system('rm -f hb_decim_filt.sv')
os.system('del /Q hb_decim_filt_h.sv')
with open('hb_decim_filt_h.sv', 'w') as fid:
    print(
        temp.render(
            name='h',
            date=time.strftime("%m/%d/%Y"),
            delay_range=(np.arange(32), np.arange(16)),
            max_delay=32,
            coeffs=hb[::2],
            adder_tree_range=np.arange(1, 4)
        ),
        file=fid)


h0 = np.array([
    -474, 0,   3818, 0, -16819, 0, 79010, 131072,
   79010, 0, -16819, 0,   3818, 0,  -474
])

hb0 = [ mybin(hk) for hk in h0 ]

#os.system('rm -f hb_decim_filtx2_h0.sv')
os.system('del /Q hb_decim_filtx2_h0.sv')
with open('hb_decim_filt_h0x2.sv', 'w') as fid:
    print(
        temp2.render(
            name='h0',
            date=time.strftime("%m/%d/%Y"),
            delay_range=(np.arange(4), np.arange(2)),
            max_delay=4,
            coeffs=hb0[::2],
            adder_tree_range=np.arange(1, 2)
        ),
        file=fid)

h1 = np.array([
     -9, 0,     83, 0,  -409,      0,  1428, 0,  -3978, 0,
   9647, 0, -22894, 0, 81669, 131072, 81669, 0, -22894, 0,
   9647, 0,  -3978, 0,  1428,      0,  -409, 0,     83, 0,
     -9
])

hb1 = [ mybin(hk) for hk in h1 ]

#os.system('rm -f hb_decim_filt_h1.sv')
os.system('del /Q hb_decim_filt_h1.sv')
with open('hb_decim_filt_h1.sv', 'w') as fid:
    print(
        temp.render(
            name='h1',
            date=time.strftime("%m/%d/%Y"),
            delay_range=(np.arange(16), np.arange(8)),
            max_delay=16,
            coeffs=hb1[::2],
            adder_tree_range=np.arange(1, 3)
        ),
        file=fid)

h2 = np.array([
     -5,      0,     19, 0,    -51, 0,   116, 0,   -233, 0,
    431,      0,   -744, 0,   1220, 0, -1916, 0,   2915, 0,
  -4339,      0,   6401, 0,  -9543, 0, 14907, 0, -26710, 0,
  83069, 131072,  83069, 0, -26710, 0, 14907, 0,  -9543, 0,
   6401,      0,  -4339, 0,   2915, 0, -1916, 0,   1220, 0,
   -744,      0,    431, 0,   -233, 0,   116, 0,    -51, 0,
     19,      0,     -5
])

hb2 = [ mybin(hk) for hk in h2 ]

#os.system('rm -f hb_decim_filt_h2.sv')
os.system('del /Q hb_decim_filt_h2.sv')
with open('hb_decim_filt_h2.sv', 'w') as fid:
    print(
        temp.render(
            name='h2',
            date=time.strftime("%m/%d/%Y"),
            delay_range=(np.arange(32), np.arange(16)),
            max_delay=32,
            coeffs=hb2[::2],
            adder_tree_range=np.arange(1, 4)
        ),
        file=fid)