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


def nyquist(N, M, alpha=1.0):
    ''' Nyquist-M Eigen Filter Design'''
    phi = np.zeros((N*M, N*M), dtype=np.double)
    fc = 0.5 * (1.0 + alpha) / M
    for ii in range(N*M):
        for jj in range(N*M):
            if ii == jj:
                phi[ii,jj] = 1 - 2 * fc
            else:
                phi[ii,jj] = -2 * fc * np.sinc(2 * fc * (ii - jj))
    # TODO: Complete this

def polyphase_sequence(period=8, periods=1, q=1, s=1):
    ''' Generate a polyphase sequence (q, s, and period should be relatively prime) '''
    x = np.zeros(period*periods, dtype=np.complex)
    if period & 1 == 0:
        for p in range(periods):
            x[period*p:period*(p+1)] = np.exp(-q*1j*np.pi*np.arange(period)**2.0/(s * period))
    else:
        for p in range(periods):
            x[period*p:period*(p+1)] = np.exp(-q*1j*np.pi*np.arange(period)*np.arange(-1, period-1)/(s * period))
    return x



if __name__ == '__main__':
    N, L, alpha = 6*1024, 1024, 1.0
    h0 = root_cosine(N, L, alpha)
    # g0 = np.convolve(h0, h0[::-1])

    # pt.figure()
    # pt.plot(np.arange(-N+1, N), g0)
    # pt.plot(np.arange(-N+1+L-1, N, L), g0[L-1::L], 'r.')

    # h1 = root_cosine(N + 1, L, alpha)
    # g1 = np.convolve(h1, h1[::-1])

    # pt.figure()
    # pt.plot(np.arange(-N, N+1), g1)
    # pt.plot(np.arange(-N, N+1, L), g1[::L], 'r.')

    period, periods, q = 8, 4, 1
    x = polyphase_sequence(periods=periods, period=period, q=q)
    # x = np.array([ 1, 1, 1,-1, 1, 1, 1,-1, 1, 1, 1,-1,-1,-1,-1, 1 ])
    pt.figure()
    pt.plot(np.real(x))
    pt.plot(np.imag(x), 'r')

    x1 = x[int(period/2-1):int(3*period/2-1)]
    x2 = x[int(period/2):int(3*period/2)]

    xd = x * np.exp(2j*np.pi*0.01*np.arange(x.size))

    y1 = np.convolve(xd, np.conjugate(x1))
    y2 = np.convolve(xd, np.conjugate(x2))

    pt.figure()
    pt.subplot(211)
    pt.plot(np.real(y1))
    pt.plot(np.imag(y1), 'r')
    pt.subplot(212)
    pt.plot(np.real(y2))
    pt.plot(np.imag(y2), 'r')

    z = y1[1:] * np.conjugate(y2[:-1])

    pt.figure()
    pt.subplot(211)
    pt.plot(np.real(z))
    pt.plot(np.imag(z), 'r')
    pt.subplot(212)
    pt.plot(np.angle(z)/(2*np.pi))

    pt.show()

