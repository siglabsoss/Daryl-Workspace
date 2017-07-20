import numpy as np
import matplotlib.pyplot as pt

from utility import root_cosine, polyphase_sequence

if __name__ == '__main__':
    L, K, alpha = 8, 6, 1.0
    P, Q = 8, 4
    Ns = 100

    h = root_cosine(K*L, L, alpha)
    spre = polyphase_sequence(period=P, periods=Q, q=3, s=1)
    s = np.sign(np.random.standard_normal(Ns))

    xs = np.zeros(L*spre.size+L*s.size, dtype=np.complex)
    xs[:L*spre.size:L] = spre
    xs[L*spre.size::L] = s

    x = np.convolve(xs, h)

    pt.figure()
    pt.plot(np.real(x))
    pt.plot(np.imag(x), 'r')

    y = np.convolve(x, h[::-1])

    pt.figure()
    pt.plot(np.real(y))
    pt.plot(np.imag(y), 'r')

    z = np.convolve(y, np.conjugate(x[:L*(spre.size+K):L]))

    pt.figure()
    pt.plot(np.real(z))
    pt.plot(np.imag(z), 'r')

    pt.show()
