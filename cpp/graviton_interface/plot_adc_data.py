import numpy as np
import matplotlib.pyplot as pt

x = np.fromfile('adcdata.bin', dtype=np.int16)

# print(x)

y = x[::2] + 1j*x[1::2]

pt.figure()
pt.plot(np.real(y))
pt.plot(np.imag(y), 'r')

Y = np.fft.fftshift(np.fft.fft(y, 2**15))

pt.figure()
pt.plot(np.arange(-2**14, 2**14)*2**-15, np.abs(Y))

pt.show()