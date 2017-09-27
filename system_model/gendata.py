import numpy as np
import matplotlib.pyplot as pt

def root_cosine(N, L, alpha, apply_window=False):
    ''' Generate root raised cosine pulse shape '''
    if (N & 1) == 0:
        # Even length
        t = np.arange(-int(N/2), int(N/2)) / float(L) + 0.5 / float(L)
    else:
        # Odd length
        t = np.arange(-int((N-1)/2), int((N-1)/2+1)) / float(L)

    h = np.zeros_like(t)

    for k in range(N):
        if t[k] == 0:
            h[k] = 1.0 - alpha + 4.0 * alpha / np.pi
        elif abs(t[k]) == 1.0 / (4.0 * alpha):
            a0 = (1.0 + 2.0 / np.pi) * np.sin(np.pi / 4.0 / alpha)
            a1 = (1.0 - 2.0 / np.pi) * np.cos(np.pi / 4.0 / alpha)
            h[k] = alpha / np.sqrt(2.0) * (a0 + a1)
        else:
            a0 = np.sin(np.pi * (1.0 - alpha) * t[k])
            a1 = 4.0 * alpha * t[k] * np.cos(np.pi * (1.0 + alpha) * t[k])
            a2 = np.pi * t[k] * (1.0 - (16.0 * alpha * alpha * t[k] * t[k]))
            h[k] = (a0 + a1) / a2

    # Hamming Window
    if apply_window:
        h *= 0.54 - 0.46 * np.cos(2*np.pi*np.arange(0, N) / (N - 1))

    return h

def pn(Q, initial_value=None):
    N = 2**Q - 1

    if Q == 3:
        fb_taps = [Q, 2]
    elif Q == 4:
        fb_taps = [Q, 3]
    elif Q == 5:
        fb_taps = [Q, 3]
    elif Q == 6:
        fb_taps = [Q, 5]
    elif Q == 7:
        fb_taps = [Q, 6]
    elif Q == 8:
        fb_taps = [Q, 6, 5, 4]
    elif Q == 9:
        fb_taps = [Q, 5]
    elif Q == 10:
        fb_taps = [Q, 7]
    elif Q == 11:
        fb_taps = [Q, 9]
    elif Q == 12:
        fb_taps = [Q, 6, 4, 1]
    elif Q == 13:
        fb_taps = [Q, 4, 3, 1]
    elif Q == 14:
        fb_taps = [Q, 5, 3, 1]
    elif Q == 15:
        fb_taps = [Q, 14]
    elif Q == 16:
        fb_taps = [Q, 15, 13, 4]
    elif Q == 17:
        fb_taps = [Q, 14]
    elif Q == 18:
        fb_taps = [Q, 11]
    elif Q == 19:
        fb_taps = [Q, 6, 2, 1]
    elif Q == 20:
        fb_taps = [Q, 17]
    elif Q == 21:
        fb_taps = [Q, 19]
    elif Q == 22:
        fb_taps = [Q, 21]
    elif Q == 23:
        fb_taps = [Q, 18]
    elif Q == 24:
        fb_taps = [Q, 23, 22, 17]
    elif Q == 25:
        fb_taps = [Q, 22]
    elif Q == 26:
        fb_taps = [Q, 6, 2, 1]
    elif Q == 27:
        fb_taps = [Q, 5, 2, 1]
    elif Q == 28:
        fb_taps = [Q, 25]
    elif Q == 29:
        fb_taps = [Q, 27]
    elif Q == 30:
        fb_taps = [Q, 6, 4, 1]
    elif Q == 31:
        fb_taps = [Q, 28]
    elif Q == 32:
        fb_taps = [Q, 22, 2, 1]
    elif Q == 33:
        fb_taps = [Q, 20]
    elif Q == 34:
        fb_taps = [Q, 27, 2, 1]
    elif Q == 35:
        fb_taps = [Q, 33]
    elif Q == 36:
        fb_taps = [Q, 25]
    elif Q == 37:
        fb_taps = [Q, 5, 4, 3, 2, 1]
    elif Q == 38:
        fb_taps = [Q, 6, 5, 1]
    elif Q == 39:
        fb_taps = [Q, 35]
    elif Q == 40:
        fb_taps = [Q, 38, 21, 19]
    elif Q == 41:
        fb_taps = [Q, 38]
    elif Q == 42:
        fb_taps = [Q, 41, 20, 19]
    elif Q == 43:
        fb_taps = [Q, 42, 38, 37]
    elif Q == 44:
        fb_taps = [Q, 43, 18, 17]
    elif Q == 45:
        fb_taps = [Q, 44, 42, 41]
    elif Q == 46:
        fb_taps = [Q, 45, 26, 25]
    elif Q == 47:
        fb_taps = [Q, 42]
    elif Q == 48:
        fb_taps = [Q, 47, 21, 20]
    elif Q == 49:
        fb_taps = [Q, 40]
    elif Q == 50:
        fb_taps = [Q, 49, 24, 23]
    elif Q == 51:
        fb_taps = [Q, 50, 36, 35]
    elif Q == 52:
        fb_taps = [Q, 49]
    elif Q == 53:
        fb_taps = [Q, 52, 38, 37]
    elif Q == 54:
        fb_taps = [Q, 53, 18, 17]
    elif Q == 55:
        fb_taps = [Q, 31]
    elif Q == 56:
        fb_taps = [Q, 55, 35, 34]
    elif Q == 57:
        fb_taps = [Q, 50]
    elif Q == 58:
        fb_taps = [Q, 39]
    elif Q == 59:
        fb_taps = [Q, 58, 38, 37]
    elif Q == 60:
        fb_taps = [Q, 59]
    elif Q == 61:
        fb_taps = [Q, 60, 46, 45]
    elif Q == 62:
        fb_taps = [Q, 61, 6, 5]
    elif Q == 63:
        fb_taps = [Q, 62]
    elif Q == 64:
        fb_taps = [Q, 63, 61, 60]
    else:
        raise ValueError("Q must be between 3 and 64.")
    
    taps = np.zeros(Q, dtype=np.int64)
    if initial_value is not None:
        taps[:] = initial_value[:]
    else:
        taps[0] = 1
    b = np.zeros(N, dtype=np.double)

    for idx in range(N):
        # Xor all taps for feedback path
        fb = taps[fb_taps[0]-1];
        for fb_tap in fb_taps[1:]:
            fb += taps[fb_tap-1]
        taps[1:] = taps[:-1]
        taps[0] = fb & 0x1

        b[idx] = 1 - 2 * float(taps[0])
    
    return b

h = root_cosine(16*4+1, 4, 1.0)

f = np.arange(-2.0**14.0, 2.0**14.0)*2.0**-14.0
H = np.fft.fftshift(np.fft.fft(h, 2**15))

# Ns = 16384
x = pn(11)

xup = np.zeros(x.size*4)
xup[::4] = x

y = np.convolve(xup, h)

Y = np.fft.fftshift(np.fft.fft(y, 2**15))

# pt.figure()
# pt.plot(h)

# pt.figure()
# pt.plot(f, np.abs(H))

# pt.figure()
# pt.plot(x)
# pt.ylim([-1.5, 1.5])

# pt.figure()
# x2 = np.zeros(2*x.size)
# x2[:x.size] = x
# x2[x.size:] = x
# Axx = np.convolve(x2, x[::-1])
# pt.plot(Axx)

# pt.figure()
# pt.plot(y)

# pt.figure()
# pt.plot(f, np.abs(Y))

# pt.figure()
# y2 = np.zeros(2*y.size)
# y2[:y.size] = y
# y2[y.size:] = y
# Ayy = np.convolve(y2, y[::-1])
# pt.plot(Ayy)

preamble = np.zeros(476*2048, dtype=np.complex)
preamble[:y.size] = y
preamble[2048*8:2048*8+y.size] = y

pt.figure()
pt.plot(np.real(preamble))
pt.plot(np.imag(preamble), 'r')

pmem = np.zeros(2048*8, dtype=np.complex)
qacc = 0.0
qout = np.zeros_like(preamble, dtype=np.complex)
qmem = np.zeros(4*x.size, dtype=np.complex)

for n, p in enumerate(preamble):
    q = p * np.conjugate(pmem[-1])
    pmem[1:] = pmem[:-1]
    pmem[0] = p

    qacc += q

    qmem[1:] = qmem[:-1]
    qmem[0] = qacc

    qout[n] = qacc - qmem[-1]

pt.figure()
pt.plot(np.real(qout))
pt.plot(np.imag(qout), 'r')

pt.figure()
quantized_preamble = np.round((2**14-1) * preamble / np.max(preamble))
quantized_preamble[quantized_preamble > 2**15-1] = 2**15-1
quantized_preamble[quantized_preamble <= -2**15] = -2**15-1
pt.plot(np.real(quantized_preamble))

pt.show()

# with open('preamble.txt', 'w') as fid:
#     for qsample in quantized_preamble:
#         fid.write('{0}, 0\n'.format(int(np.real(qsample))))

