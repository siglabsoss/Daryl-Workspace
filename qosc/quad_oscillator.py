import numpy as np
import matplotlib.pyplot as pt

N = int(63 * 250)
fc = 31.5 / 250.0
k1 = np.tan(np.pi*fc)
k2 = np.sin(2*np.pi*fc)

u, v = 1.0, 0.0
k1v = 0.0

x = np.zeros(N, dtype=np.complex)

for index in range(N):
    x[index] = u + 1j * v
    w = u - k1v
    v = v + k2 * w
    k1v = k1 * v
    u = w - k1v

pt.figure()
pt.plot(np.real(x))
pt.plot(np.imag(x))

pt.figure()
freqs = np.arange(-N/2, N/2) / float(N)
X = np.fft.fftshift(np.fft.fft(x, N))
pt.plot(freqs, 20*np.log10(np.abs(X)))

pt.show()
