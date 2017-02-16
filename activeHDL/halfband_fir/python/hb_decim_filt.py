import numpy as np
import matplotlib.pyplot as pt

# Reference: A "TRICK" for the Design of FIR Half-Band Filters by Vaidyanathan and Nguyen
#    -----> Only used to design the coefficients, the lattice structure was not used.

h = [  -122, 0,   187, 0,   -323, 0,    517, 0,   -785, 0,   1146, 0,  -1622, 0,  2243,      0,
      -3051, 0,  4112, 0,  -5533, 0,   7520, 0, -10511, 0,  15656, 0, -27184, 0, 83231, 131072,
      83231, 0,-27184, 0,  15656, 0, -10511, 0,   7520, 0,  -5533, 0,   4112, 0, -3051,      0,
       2243, 0, -1622, 0,   1146, 0,   -785, 0,    517, 0,   -323, 0,    187, 0,  -122 ]
h = np.array(h)

e0, e1 = h[::2], h[1::2]

pt.plot(e0)
pt.plot(e1)
pt.show()

x = np.random.standard_normal(4096)
# x = np.cos(2*np.pi*50/2048.0*np.arange(8192)) + np.sin(2*np.pi*900/2048.0*np.arange(8192))
y = np.zeros(x.size//2)

tdl0= np.zeros(e0.size)
tdl1 = np.zeros(e0.size//2)
factors = np.zeros(e0.size//2)

for n, xn in enumerate(x):
    if n % 2 == 0:
        tdl0[1:], tdl0[0] = tdl0[0:-1], xn
        for idx in range(e0.size//2):
            factors[idx] = tdl0[idx] + tdl0[-idx-1]
        e0_output = np.sum(factors * e0[:e0.size//2])
        y[n//2] = tdl1[e0.size//2-1] * (1 << 17) + e0_output
    else:
        tdl1[1:], tdl1[0] = tdl1[0:-1], xn


# x2 = np.zeros(2*x.size)
# x2[::2] = x
# y = np.convolve(x2, h)
y0 = np.convolve(x, h)[::2]
# y[::2] = y0[:y.size//2]
# y[1::2] = y1[:y.size//2]

y /= 2**18
y0 /= 2**18

X = np.fft.fftshift(np.fft.fft(x[1024:4096+1024], 4096))
Y = np.fft.fftshift(np.fft.fft(y[1024:2048+1024], 2048))

pt.figure()
pt.subplot(2,1,1)
pt.plot(x)
pt.subplot(2,1,2)
pt.plot(y, 'g')
pt.plot(np.arange(0, y0.size), y0, 'g.')

pt.figure()
pt.subplot(2,1,1)
pt.plot(np.arange(-2048, 2048)/4096.0, 20*np.log10(np.abs(X)))
pt.xlim([-0.5, 0.5])
pt.subplot(2,1,2)
pt.plot(np.arange(-1024, 1024)/2048.0, 20*np.log10(np.abs(Y)), 'g')
pt.xlim([-0.5, 0.5])

pt.show()
