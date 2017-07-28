import numpy as np
import matplotlib.pyplot as pt
from utility import raised_cosine, quantize


def dds_gen(phi_seq, N=16, K=256, M=256):
    ''' Direct Digital Synthesizer - based on interpolation of stored sine wave.

    This function is a python generator function that demonstrates the algorithm
    for a direct digital synthesizer of a complex exponential with an arbitrary
    phase input phi_seq.

    M is the samples per period of the stored values.
    2*K is the number of periods of the raised cosine to use.
    2*N*K+1 is the length of the filter to use. '''

    # Make sure lengths are powers of 2 (only required for easy counters and symmetry optimizations)
    assert M & (M >> 1) == 0 # M is power of 2
    assert K & (K >> 1) == 0 # K is power of 2

    # Initialize a half period of cosine samples
    cos_buf = quantize(np.cos(2*np.pi*np.arange(M / 2) / float(M)))
    # Note: cos[n] = (-1)**float(n % M >= M/2) * cos_buf[n % (M/2)] due to half wave symmetry
    # Note: sin[n] = cos[n - M/4] since M is a power of 2


def arbitrary_cos_lookup(n, cos_buf, M):
    ''' Cosine Lookup, exploiting half wave symmetry '''
    if (n % M) >= (M / 2):
        s = -cos_buf[n % (M / 2)]
    else:
        s = cos_buf[n % (M / 2)]

    return s


def arbitrary_sin_lookup(n, cos_buf, M):
    ''' Sine Lookup, exploiting sin(t) = cos(t - 0.5*pi)'''
    c = arbitrary_cos_lookup((n - M/4) % M, cos_buf, M)

    return c


def test_dds_gen():
    ''' Simple test for DDS function '''
    N, K, M = 16, 256, 256
    phi = np.arange(M)

    cos_buf = quantize(np.cos(2*np.pi*np.arange(M / 2) / float(M))) / (2**17 - 1)

    x1 = [ arbitrary_cos_lookup(phi_n, cos_buf, M) for phi_n in phi ]
    x2 = np.cos(2*np.pi * phi / M)

    x3 = [ arbitrary_sin_lookup(phi_n, cos_buf, M) for phi_n in phi ]
    x4 = np.sin(2*np.pi * phi / M)

    # pt.figure()
    # pt.plot(sin_buf)
    # pt.plot([s for s in sin_buf] + [-s for s in sin_buf], 'r-.')

    pt.figure()
    pt.subplot(211)
    pt.plot(phi, x1)
    pt.plot(phi, x3, 'r')
    pt.subplot(212)
    pt.plot(phi, x2)
    pt.plot(phi, x4, 'r')

    pt.figure()
    pt.subplot(211)
    pt.plot(phi, np.abs(x2 - x1))
    pt.subplot(212)
    pt.plot(phi, np.abs(x4 - x3))

    pt.show()


if __name__ == '__main__':
    test_dds_gen()

    # N, K, alpha = 16, 32, 0.5
    # g = raised_cosine(2*K*N+1, N, alpha)
    #
    # # Even though K*M copies are here, it is periodic in K so only M samples are needed
    # M, nco_count = 32, 0
    # mem_buf = np.zeros(K*M, dtype=np.complex)
    # mem_buf += quantize(np.cos(-2*np.pi*np.arange(K*M)/float(M)))
    # mem_buf += 1j * quantize(np.sin(-2*np.pi*np.arange(K*M)/float(M)))
    # # mem_buf += np.cos(-2 * np.pi * np.arange(M) / float(M))
    # # mem_buf += 1j * np.sin(-2 * np.pi * np.arange(M) / float(M))
    #
    # Nfft = 2**18
    #
    # y = np.zeros(Nfft, dtype=np.complex)
    #
    # nco_increment = 1
    #
    # print "Estimated frequency = {0}".format(float(nco_increment)/float(M*N))
    #
    # for index in range(Nfft):
    #     nco_count = nco_count + nco_increment
    #
    #     polyphase_component_index = nco_count % N
    #     rotation_index = (nco_count // N) % M
    #
    #     P = len(g[polyphase_component_index::N])
    #     y[index] = np.dot(np.roll(mem_buf, rotation_index)[:P], g[polyphase_component_index::N])
    #
    # y = quantize(y) / (2.0**17 - 1)
    #
    # pt.figure()
    # pt.plot(np.real(y[:int(2*N*M/nco_increment)]))
    # pt.plot(np.imag(y[:int(2*N*M/nco_increment)]), 'r')
    #
    # pt.figure()
    # Y = np.fft.fftshift(np.fft.fft(y, 2**18) + 1e-20)
    # f = np.arange(-2.0**17, 2.0**17)/(2.0**18)
    # pt.plot(f, 20*np.log10(np.abs(Y)), 'k')
    # pt.xlim([-0.5, 0.5])
    #
    # pt.show()

