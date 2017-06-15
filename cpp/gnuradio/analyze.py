import numpy as np
import matplotlib.pyplot as pt

x = np.fromfile('datadump.bin', np.uint16, count=50*16384)

y = np.int32(x)
y[y >= 2**15] -= 2**16


pt.figure()
pt.plot(y[::2])
pt.plot(y[1::2])

pt.figure()
Y = np.fft.fft(y, 2*16384)
pt.plot(np.arange(-16384, 16384)/(2.0*16384), np.abs(Y))

pt.show()
