import numpy as np
import matplotlib.pyplot as pt

from utility import root_cosine, polyphase_sequence

if __name__ == '__main__':
    L, K, alpha = 8, 6, 1.0
    P, Q = 8, 4
    Ns = 100

    zero_size = K*L
    h = root_cosine(K*L, L, alpha)
    spre = polyphase_sequence(period=P, periods=Q, q=3, s=1)
    s = np.sign(np.random.standard_normal(Ns))

    xs = np.zeros(L*spre.size+L*s.size+zero_size, dtype=np.complex)
    xs[zero_size:zero_size+L*spre.size:L] = spre
    xs[zero_size+L*spre.size::L] = s

    x = np.convolve(xs, h)

    pt.figure()
    pt.plot(np.real(x))
    pt.plot(np.imag(x), 'r')

    y = np.convolve(x, h[::-1])

    pt.figure()
    pt.plot(np.real(y))
    pt.plot(np.imag(y), 'r')

    P3 = np.sqrt(np.sum(np.abs(xs[zero_size+P*L/2:zero_size+3*P*L/2])**2.0) / P)

    xs1 = np.conjugate(xs[zero_size+P*L/2:zero_size+3*P*L/2]) / P3
    xs2 = np.conjugate(xs[zero_size+P*L/2-L:zero_size+3*P*L/2-L]) / P3

    z1 = np.convolve(y, xs1)
    z2 = np.convolve(y, xs2)
    z3 = np.sqrt(np.convolve(y*np.conjugate(y), np.ones(L*P)/(L*P)))


    pt.figure()
    pt.subplot(311)
    pt.plot(np.real(z1))
    pt.plot(np.imag(z1), 'r')
    pt.subplot(312)
    pt.plot(np.real(z2))
    pt.plot(np.imag(z2), 'r')
    pt.subplot(313)
    pt.plot(np.real(z3))
    pt.plot(np.imag(z3), 'r')

    pt.show()
