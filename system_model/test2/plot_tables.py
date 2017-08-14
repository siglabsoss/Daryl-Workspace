import numpy as np
import matplotlib.pyplot as pt

SNR_list     = [-10, -5, -3, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 15, 20, 25, 30]
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

    # pt.figure()
    # pt.plot(ac, diff, '.')
    # pt.xlabel('AC estimate')
    # pt.ylabel('Diff estimate')

    if SNR == 20:
        ac_mse_est = 10**(-SNR/10.0)
        ac_mean_est = ac[0]
        unsmoothed_mean = []
        smoothed_mean = []
        smoothed_mse = []
        for k, ac_est in enumerate(ac):
            # ac_est += np.floor(k/100.0)
            unsmoothed_mean.append(ac_est)
            ac_predicted = ac_mean_est
            mse_predicted = ac_mse_est + 5e-2*10**(-SNR/10)
            kalman_gain = mse_predicted / (10**(-SNR/10.0) + mse_predicted)
            ac_mean_est = ac_predicted + kalman_gain * (ac_est - ac_predicted)
            ac_mse_est = (1 - kalman_gain) * ac_mse_est
            smoothed_mean.append(ac_mean_est)
            smoothed_mse.append(ac_mse_est)

        pt.figure()
        pt.subplot(211)
        pt.plot(unsmoothed_mean)
        pt.plot(smoothed_mean)
        pt.xlabel('Frame Number')
        pt.ylabel('Estimated Mean')
        pt.subplot(212)
        pt.plot(smoothed_mse)
        pt.xlabel('Frame Number')
        pt.ylabel('Estimated MSE')

    if SNR == 5:
        f = pt.figure()
        pt.plot(np.abs(ac)**2.0)
        pt.xlabel('Sample number')
        pt.ylabel('AC estimate')
    elif SNR == 10:
        pt.figure(f.number)
        pt.plot(np.abs(ac)**2.0, 'r')
    elif SNR == 20:
        pt.figure(f.number)
        pt.plot(np.abs(ac)**2.0, 'g')
    elif SNR == 30:
        pt.figure(f.number)
        pt.plot(np.abs(ac)**2.0, 'k')
        pt.legend(['SNR=5', 'SNR=10', 'SNR=20', 'SNR=30'])

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
