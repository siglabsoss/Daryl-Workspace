import numpy as np
import matplotlib.pyplot as pt

SNR_list     = [-20, -15, -10, -5, -3, 0, 1, 2, 3, 4, 5, 10, 15, 20, 25, 30]
ac_mean      = []
ac_std_dev   = []
diff_mean    = []
diff_std_dev = []

for SNR in SNR_list:
    ac, diff = [], []
    with open("table{0}SNR.txt".format(SNR), "r") as fid:
        for line in fid:
            for n, val in enumerate(line.split(',')):
                if n == 0:
                    ac.append(int(val))
                else:
                    diff.append(int(val))

    pt.figure()
    pt.plot(ac, diff, '.')
    pt.xlabel('AC estimate')
    pt.ylabel('Diff estimate')

    ac_mean.append(np.mean(ac))
    ac_std_dev.append(np.sqrt(np.var(ac)))
    diff_mean.append(np.mean(diff))
    diff_std_dev.append(np.sqrt(np.var(diff)))

pt.figure()
pt.plot(SNR_list, ac_mean)
pt.plot(SNR_list, diff_mean)
pt.xlabel('SNR (in dB)')
pt.ylabel('Mean value of estimates')

pt.figure()
pt.plot(SNR_list, ac_std_dev)
pt.plot(SNR_list, diff_std_dev)
pt.xlabel('SNR (in dB)')
pt.ylabel('Standard deviation of estimates')

pt.show()
