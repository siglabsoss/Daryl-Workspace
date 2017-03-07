import os, time
import numpy as np
import jinja2

h = np.array([
    163,
    -629,
    -223,
    2447,
    -2564,
    -3222,
    9836,
    -4201,
    -15254,
    23990,
    3427,
    -44842,
    35095,
    42736,
    -87836,
    -8075,
    131072,
    -8075,
    -87836,
    42736,
    35095,
    -44842,
    3427,
    23990,
    -15254,
    -4201,
    9836,
    -3222,
    -2564,
    2447,
    -223,
    -629,
    163
])

half_order_of_h = (len(h)-1) // 2;
h_binary = []
for hn in h[:half_order_of_h]:
    if hn < 0:
        hnc = 2**18 + hn
        h_binary.append('{0:018b}'.format(hnc))
    else:
        h_binary.append('{0:018b}'.format(hn))

env = jinja2.Environment(loader=jinja2.FileSystemLoader('templates'))
temp = env.get_template('cic_compfir.svt')

#os.system('rm -f cic_compfir.sv')
os.system('del /Q cic_compfir.sv')
with open('cic_compfir.sv', 'w') as fid:
    print(
        temp.render(
            romname='cic_compfir',
            date=time.strftime("%m/%d/%Y"),
            half_order_of_h=half_order_of_h,
            h_binary=h_binary
        ),
        file=fid)