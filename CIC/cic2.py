import numpy as np
import matplotlib.pyplot as pt

np.seterr(divide='ignore')

Nfft = 64 * 16384

N = 313
K = 2
P = 5

fracband = (100.0/8.0)/100.0

f = np.arange(-Nfft/2, Nfft/2)/float(Nfft)
X = np.fft.fftshift(np.fft.fft(np.ones(K*N)/(K*N), Nfft))
Y0, Y1 = 0*np.ones(f.shape), 0*np.ones(f.shape)
Y0[np.abs(f) < 0.5*fracband/N] = 1
Y1[np.abs(f - 1.0/N) < 0.5*fracband/N] = 1

# print("    No Correction: {0}".format(
#   np.sqrt(np.mean(np.abs(1 - np.abs(Y0 * X**P))**2.0))))

# alpha_range = np.arange(-5.0, 5.0, 0.1)
alpha_range = np.arange(0.2, 0.50, 0.001)
rms_error = np.zeros_like(alpha_range)
ripple_error = np.zeros_like(alpha_range)
Nh = N
PH = P
iteration = 0
for alpha in alpha_range:
    h = np.zeros(3*Nh)
    h[::Nh] = np.array([-0.5 * alpha, 1.0 + alpha, -0.5 * alpha ])
    h /= np.sum(h)
    H = np.fft.fftshift(np.fft.fft(h, Nfft))
    Z = np.abs(Y0 * H**PH * (X)**P)
    ripple_error[iteration] = np.max(Z[Y0 > 0.5]) - np.min(Z[Y0 > 0.5])
    rms_error[iteration] = np.sqrt(np.mean(np.abs(1 - Z[Y0 > 0.5])**2.0))
    iteration += 1

pt.figure()
pt.plot(alpha_range, rms_error)

# Ripple error seems like the best metric so far
pt.figure()
pt.plot(alpha_range, ripple_error)

pt.show()

