import os, time
import numpy as np
import jinja2

h = np.array([
          32,
          16,
        -148,
        -273,
         -48,
         281,
          77,
        -426,
        -193,
         593,
         365,
        -795,
        -616,
        1028,
         964,
       -1291,
       -1430,
        1575,
        2038,
       -1872,
       -2818,
        2168,
        3800,
       -2443,
       -5022,
        2671,
        6530,
       -2815,
       -8380,
        2825,
       10647,
       -2622,
      -13434,
        2088,
       16889,
       -1022,
      -21231,
        -938,
       26789,
        4509,
      -34046,
      -11250,
       43547,
       24980,
      -54780,
      -56099,
       56893,
      131072,
       56893,
      -56099,
      -54780,
       24980,
       43547,
      -11250,
      -34046,
        4509,
       26789,
        -938,
      -21231,
       -1022,
       16889,
        2088,
      -13434,
       -2622,
       10647,
        2825,
       -8380,
       -2815,
        6530,
        2671,
       -5022,
       -2443,
        3800,
        2168,
       -2818,
       -1872,
        2038,
        1575,
       -1430,
       -1291,
         964,
        1028,
        -616,
        -795,
         365,
         593,
        -193,
        -426,
          77,
         281,
         -48,
        -273,
        -148,
          16,
          32
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
            h_binary=h_binary,
            max_filter_gain=int(np.ceil(np.log2(np.sum(np.abs(h))))),
            log2_dc_gain=int(np.ceil(np.log2(np.sum(h))))
        ),
        file=fid)