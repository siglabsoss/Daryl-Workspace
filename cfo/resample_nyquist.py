import numpy as np
import matplotlib.pyplot as pt
from utility import root_cosine


if __name__ == '__main__':
    h = root_cosine(10*8, 8, 0.25)
    s = np.sign(np.random.standard_normal(100))
    xs = np.zeros(8*100, dtype=np.complex)
    xs[::8] = s

    x1 = np.convolve(xs, h)
    x2 = np.convolve(x1, h[::-1])

    pt.figure()
    pt.plot(np.real(x2[8*10-1::8]))

    # M = 400
    # x3 = np.zeros(M*x2.size, dtype=np.complex)
    # x3[::M] = x2

    P = 100
    h2 = root_cosine(8*P+1, P, 0.5)
    g2 = np.convolve(h2, h2[::-1])
    g2 = g2 / np.max(np.abs(g2))

    # pt.figure()
    # pt.plot(g2)

    # X3 = np.fft.fftshift(np.fft.fft(x3, 2**16))
    # H2 = np.fft.fftshift(np.fft.fft(h2, 2**16))

    # pt.figure()
    # pt.plot(np.arange(-2**15, 2**15)/2.0**16, np.abs(X3))
    # pt.plot(np.arange(-2**15, 2**15)/2.0**16, np.abs(H2))

    tau = 10
    x4 = np.convolve(x2, g2[tau::P])
    x4d = x4[8*10-1+8::8]
    x5 = np.convolve(x4, g2[P-tau::P])
    x5d = x5[8*10-2+8+8::8]

    pt.figure()
    pt.title('Resample')
    pt.subplot(211)
    pt.plot(np.real(x4d))
    pt.plot(np.imag(x4d), 'r')
    pt.subplot(212)
    pt.plot(np.real(x5d))
    pt.plot(np.imag(x5d), 'r')


    pt.show()