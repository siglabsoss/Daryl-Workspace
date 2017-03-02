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

# Controls number of H's to cascade
PH = P
Nh = N
alpha = 0.344
h = np.zeros(3*Nh)
h[::Nh] = np.array([-0.5 * alpha, 1.0 + alpha, -0.5 * alpha ])
h /= np.sum(h)
H = np.fft.fftshift(np.fft.fft(h, Nfft))

pt.figure()
pt.plot(f, np.abs(X)**P)
pt.plot(f, np.abs(Y0)**P)
pt.plot(f, np.abs(Y1)**P)
pt.plot(f, np.abs(H)**PH)

pt.figure()
pt.plot(f, 20*np.log10(np.abs(X)**P))
pt.plot(f, 20*np.log10(np.abs(Y0 + 1e-12)**P))
pt.plot(f, 20*np.log10(np.abs(Y1 + 1e-12)**P))
pt.plot(f, 20*np.log10(np.abs(H)**PH))
pt.xlim([-0.5/N, 1.5/N])
pt.ylim([-150, 10])

pt.figure()
pt.plot(f, np.abs(H**PH * X**P))
pt.plot(f, np.abs(Y0)**P)
pt.plot(f, np.abs(Y1)**P)

pt.figure()
pt.plot(f, 20*np.log10(np.abs(H**PH * X**P)))
pt.plot(f, 20*np.log10(np.abs(Y0 + 1e-12)**P))
pt.plot(f, 20*np.log10(np.abs(Y1 + 1e-12)**P))

pt.xlim([-0.5/N, 1.5/N])
pt.ylim([-150, 10])

pt.show()

