import numpy as np
import matplotlib.pyplot as pt
from utility import root_cosine, quantize


if __name__ == '__main__':
    N, K, alpha = 2048, 8, 0.5
    h = root_cosine(K*N+1, N, alpha)
    g = np.convolve(h, h[::-1])
    # g = quantize(g)

    # M >= 2*K+1
    M, nco_count = 4*K, 0
    mem_buf = np.zeros(M, dtype=np.complex)
    # mem_buf += quantize(np.cos(-2*np.pi*np.arange(M)/float(M)))
    # mem_buf += 1j * quantize(np.sin(-2*np.pi*np.arange(M)/float(M)))
    mem_buf += np.cos(-2 * np.pi * np.arange(M) / float(M))
    mem_buf += 1j * np.sin(-2 * np.pi * np.arange(M) / float(M))

    y = np.zeros(2**18, dtype=np.complex)

    nco_increment = 1

    print "Estimated frequency = {0}".format(float(nco_increment)/float(M*N))

    for index in range(2**18):
        nco_count = nco_count + nco_increment

        polyphase_component_index = nco_count % N
        rotation_index = (nco_count // N) % M

        P = len(g[polyphase_component_index::N])
        y[index] = np.dot(np.roll(mem_buf, rotation_index)[:P], g[polyphase_component_index::N])

    pt.figure()
    pt.plot(np.real(y[:2*N*M]))
    pt.plot(np.imag(y[:2*N*M]), 'r')

    pt.figure()
    Y = np.fft.fftshift(np.fft.fft(y, 2**18) + 1e-20)
    f = np.arange(-2.0**17, 2.0**17)/(2.0**18)
    pt.plot(f, 20*np.log10(np.abs(Y)), 'k')

    pt.show()

