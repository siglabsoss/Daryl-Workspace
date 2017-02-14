import numpy as np
import matplotlib.pyplot as pt


h = [ -122,  0,   187, 0,   -323,  0,    517,  0,   -785, 0,   1146, 0,  -1622, 0,  2243,      0,
      -3051, 0,  4112, 0,  -5533,  0,   7520,  0, -10511, 0,  15656, 0, -27184, 0, 83231, 131072,
      83231, 0,-27184, 0,  15656,  0, -10511,  0,   7520, 0,  -5533, 0,   4112, 0, -3051,      0,
       2243, 0, -1622, 0,   1146,  0,   -785,  0,    517, 0,   -323, 0,    187, 0,  -122 ]
h = np.array(h)

e0, e1 = h[::2], h[1::2]

pt.plot(e0)
pt.plot(e1)
pt.show()

# x = np.random.standard_normal(2048)
x = np.cos(2*np.pi*100/2048*np.arange(2048))
y = np.zeros(2*x.size)

tdl = np.zeros(e0.size)
factors = np.zeros(e0.size//2)
products = np.zeros_like(e0.size//2)

for n, xn in enumerate(x):
    tdl[1:], tdl[0] = tdl[0:-1], xn
    for idx in range(e0.size//2):
        factors[idx] = tdl[idx] + tdl[-idx-1]
    products = factors * e0[:e0.size//2]
    y[2*n+1] = tdl[e0.size//2-1] * (1 << 17)
    y[2*n] = np.sum(products)

# x2 = np.zeros(2*x.size)
# x2[::2] = x
# y = np.convolve(x2, h)
y0 = np.convolve(x, e0)
y1 = np.convolve(x, e1)
# y[::2] = y0[:y.size//2]
# y[1::2] = y1[:y.size//2]

y /= 2**17
y0 /= 2**17
y1 /= 2**17

X = np.fft.fftshift(np.fft.fft(x))
Y = np.fft.fftshift(np.fft.fft(y[1024:2048+1024], 2048))

pt.figure()
pt.subplot(2,1,1)
pt.plot(x)
pt.subplot(2,1,2)
pt.plot(y)
pt.plot(np.arange(0, 2*y0.size, 2), y0, 'g.')
pt.plot(np.arange(1, 2*y1.size, 2), y1, 'r.')


pt.figure()
pt.plot(np.arange(-1024, 1024)/2048.0, 20*np.log10(np.abs(X)))
pt.plot(np.arange(-1024, 1024)/2048.0, 20*np.log10(np.abs(Y)))
pt.xlim([-0.5, 0.5])

pt.show()
