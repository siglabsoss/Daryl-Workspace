import numpy as np


def raised_cosine(N, L, alpha, apply_window=False):
    ''' Generate a raised cosine pulse shape '''
    if N & 1 == 0:
        # Even length
        t = np.arange(-int(N/2), int(N/2)) / float(L) + 0.5 / float(L)
    else:
        # Odd length
        t = np.arange(-int((N-1)/2), int((N-1)/2+1)) / float(L)

    h = np.zeros_like(t)

    for k in range(N):
        if abs(t[k]) == 0.5 / alpha:
            h[k] = 0.25 * np.pi *np.sinc(0.5 / alpha)
        else:
            h[k] = np.sinc(t[k]) * np.cos(np.pi*alpha*t[k]) / (1 - (2.0*alpha*t[k])**2.0)

    if apply_window:
        h *= np.hamming(h.size)

    return h


def root_cosine(N, L, alpha, apply_window=False):
    ''' Generate root raised cosine pulse shape '''
    if N & 1 == 0:
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

    if apply_window:
        h *= np.hamming(h.size)

    return h


def quantize(x, Nb = 18, bypass=False, maximize_range=True, integral_type=False):
    ''' Perform rounding to nearest integer for maximum dynamic range '''
    q_max = 2**(Nb - 1) - 1

    if maximize_range:
        x_max = np.max(np.abs(x))
    else:
        x_max = 1.0

    y = np.round(q_max * x / x_max)

    if integral_type:
        if Nb <= 16:
            y = np.int16(y)
        elif Nb <= 32:
            y = np.int32(y)
        elif Nb <= 64:
            y = np.int64(y)
        elif Nb <= 128:
            y = np.int128(y)

    return y


if __name__ == '__main__':
    import matplotlib.pyplot as pt

    h = root_cosine(6*128+1, 128, 1.0)

    pt.figure()
    pt.plot(h)

    g = raised_cosine(7*128+1, 128, 0.5, apply_window=True)

    pt.figure()
    pt.plot(g)
    tau = 64

    pt.plot(np.arange(tau, g.size, 128), g[tau::128], 'o')

    pt.show()
