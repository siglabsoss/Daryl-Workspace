# Python model of synthesis and analysis polyphase filter banks

import numpy as np
import matplotlib.pyplot as pt

#####################
# Simple Pulse Shape
#####################

def root_cosine(N, L, alpha):
    ''' Generate root raised cosine pulse shape '''
    t = np.arange(-N/2, N/2) / float(L) + 0.5 / float(L)
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

    return h

##################################
# Start of Transmitter Generators
##################################

def bpsk_gen(Ns, terminating_zeros=0, repetitions=1, Na=0):
    ''' BPSK Generator '''
    preamble = np.sign(np.random.standard_normal(Na)) * (1 + 1j) / np.sqrt(2.0)
    for rep in range(8):
        for psym in preamble:
            if rep % 4 == 3:
                yield psym
            else:
                yield -psym
    s = np.sign(np.random.standard_normal(Ns))
    for rep in range(repetitions):
        for index in range(Ns):
            yield s[index]
    for index in range(terminating_zeros):
        yield 0.0

def ifft_frame_gen(sym_gen, N, active_list=[0, 1, 2, 3, 4, -4, -3, -2, -1]):
    ''' Provides framed data for the IFFT block '''
    frame_data = np.zeros(N, dtype=np.complex)
    active_index = 0
    for s in sym_gen:
        frame_data[active_list[active_index]] = s
        active_index += 1
        if active_index >= len(active_list):
            active_index = 0
            yield frame_data

def ifft_gen(frame_gen, N, Npre=0, Npost=0):
    ''' Perform IFFT (undo affect of normalization)
        also contains logic to add a cyclic prefix
        and/or a cyclic postfix. '''
    for frame in frame_gen:
        fd_frame = np.fft.ifft(N * frame)
        for n in range(Npre):
            yield fd_frame[N-Npre+n]
        for n in range(N):
            yield fd_frame[n]
        for n in range(Npost):
            yield fd_frame[n]

def spp_gen(sample_gen, hproto, N, L):
    ''' Perform N time-varying synthesis polyphase filters sourced
        from hproto's Lth polyphase decomposition. '''
    pp_buf = np.zeros((N, int(np.ceil(len(hproto) / L))), dtype=np.complex)
    p = 0
    for n, sn in enumerate(sample_gen):
        nmodN = n % N
        pp_buf[nmodN,1:], pp_buf[nmodN, 0] = pp_buf[nmodN,:-1], sn
        if nmodN == N - 1:
            for q in range(L):
                yield np.sum(pp_buf[p,:] * hproto[q::L])
                p = (p + 1) % N
for SNR in [-20, -15, -10, -5, 0, 5, 10, 15, 20, 25, 30]:
    ##################################
    # Start of Simulation Parameters
    ##################################

    # Generate prototype filter
    N, L, K = 1024, 2048, 6
    alpha = (float(L) / float(N)) - 1.0
    h = root_cosine(K * L, L, alpha)

    # Symbol Parameters (determines length of simulation)
    active = [ a for a in range(0, 301) ] + [ a for a in range(-300, 0) ]
    Na = len(active)
    Ns = Na * 40

    # Generator chain for synthesis filter bank
    x1 = bpsk_gen(Ns, terminating_zeros=Na*(K+30), repetitions=1, Na=Na)
    x1 = [ x1k for x1k in x1 ]
    x2 = ifft_frame_gen(x1, N, active)
    x3 = ifft_gen(x2, N, Npre=0, Npost=0)
    x4 = spp_gen(x3, h, N, L)

    # Run SFB to obtain an array of TX samples
    x = np.array([ 0 for n in range(30*N - 1) ] + [ xn for xn in x4 ])

    # Plot some things to demonstrate that the SFB is functional
    plot_tx = False
    if plot_tx:
        # Raw samples at SFB output
        pt.figure()
        pt.plot(np.real(x))
        pt.plot(np.imag(x), 'r')

        # SFB output spectrum
        f = np.arange(-12*L, 12*L) / (24.0*L)
        X = np.fft.fftshift(np.fft.fft(x, 24*L))
        pt.figure()
        pt.plot(f, 20*np.log10(np.abs(X)))
        pt.xlim([-0.5, 0.5])

        # Demodulation of a subcarrier to baseband and matched filtering
        carrier = np.exp(-active[0]*2j*np.pi*np.arange(x.size)/N)
        xdemod = np.convolve(carrier * x, h[::-1])
        pt.figure()
        pt.plot(np.real(xdemod))
        pt.plot(np.arange(K*L-1, xdemod.size, L), np.real(xdemod[K*L-1::L]), 'o')
        pt.plot(np.imag(xdemod), 'r')
        pt.plot(np.arange(K*L-1, xdemod.size, L), np.imag(xdemod[K*L-1::L]), 'ro')

        # # Plot of the Nyquist and Root Nyquist responses of the prototype filter
        # pt.figure()
        # pt.subplot(211)
        # pt.plot(h)
        # pt.subplot(212)
        # pt.plot(np.convolve(h, h[::-1]))

        # pt.show()

    SNR_linear = 10**(SNR/10)
    sigma_v = np.sqrt(np.var(x[x != 0])/SNR_linear)
    v = np.random.standard_normal(x.shape) + 1j*np.random.standard_normal(x.shape)
    x += sigma_v * v

    x_max = np.max(np.abs(x))
    xq = np.round((2**14) * x / x_max)

    def mybin(x, N=36):
        if N == 32:
            if x < 0:
                return '{:036b}'.format(2**N + x)
            else:
                return '{:036b}'.format(x)
        elif N == 18:
            if x < 0:
                return '{:018b}'.format(2**N + x)
            else:
                return '{:018b}'.format(x)
        elif N == 16:
            if x < 0:
                return '{:016b}'.format(2**N + x)
            else:
                return '{:016b}'.format(x)
        elif N == 8:
            if x < 0:
                return '{:08b}'.format(2**N + x)
            else:
                return '{:08b}'.format(x)
        else:
            if x < 0:
                return '{:0b}'.format(2**N + x)
            else:
                return '{:0b}'.format(x)

    # with open('test_vectors.txt', 'wt') as fid:
    #     for xqn in xq:
    #         xbim = mybin(int(np.imag(xqn)), 16)
    #         xbre = mybin(int(np.real(xqn)), 16)
    #         fid.write("{0}{1}\n".format(xbim, xbre))

    normalize = False # True
    if normalize:
        xq /= (2.0**16)

    sample_delays = np.zeros(int(4*L), dtype=np.complex)
    pow_delays = np.zeros(int(4*L))
    ac_delays = np.zeros(int(4*L), dtype=np.complex)
    pow_output = np.zeros_like(xq)
    ac_output = np.zeros_like(xq, dtype=np.complex)
    pow_acc = 0
    ac_acc = 0
    n = 0
    for xqn in xq:
        ac_temp = xqn * np.conjugate(sample_delays[-1])
        pow_temp = 0.5 * (np.abs(xqn)**2.0 + np.abs(sample_delays[-1])**2.0)
        sample_delays[1:], sample_delays[0] = sample_delays[:-1], xqn

        pow_delays[1:], pow_delays[0] = pow_delays[:-1], pow_temp
        ac_delays[1:], ac_delays[0] = ac_delays[:-1], ac_temp

        pow_diff = pow_temp - pow_delays[-1]
        ac_diff = ac_temp - ac_delays[-1]

        pow_acc += pow_diff
        ac_acc += ac_diff

        pow_output[n] = pow_acc
        ac_output[n] = ac_acc
        n += 1

    # pt.figure()
    # pt.plot(np.real(xq))
    # pt.plot(np.imag(xq), 'r')

    # pt.figure()
    # pt.plot(np.abs(pow_output))
    # pt.plot(np.abs(ac_output), 'r')

    # pt.figure()
    diffy = np.abs(ac_output)**2.0 - np.abs(pow_output)**2.0
    # pt.plot(diffy)

    k1 = 50000 + np.argmin(np.abs(ac_output[50000:55000] - np.max(np.abs(ac_output[50000:55000]))))
    k2 = 50000 + np.argmin(np.abs(diffy[50000:55000] - np.max(diffy[50000:55000])))

    print("ac = {0}; diff = {1}".format(k1, k2))

    with open("table{0}SNR.txt".format(SNR), "a+") as fid:
        fid.write("{0}, {1}\n".format(k1, k2))

# pt.show()
