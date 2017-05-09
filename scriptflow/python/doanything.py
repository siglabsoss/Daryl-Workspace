import numpy as np
import matplotlib.pyplot as pt

def signer(x, N=16):
    if x >= 2**(N-1):
        return -2**N + x
    else:
        return x

fid = open('anal18.txt')

BITS=16

data = []
data_point = 0
for line in fid:
    for idx, word in enumerate(line.strip().split(' ')):
        if idx == 2:
            # print("I = {0}".format(signer(int(word, base=2))))
            data_point = signer(int(word[::-1], base=2), BITS) + 0j
        elif idx == 4:
            # print("Q = {0}".format(signer(int(word, base=2))))
            data_point += 1j*signer(int(word[::-1], base=2), BITS)
        elif idx == 6:
            if word == '1':
                data.append(np.real(data_point))
                data.append(np.imag(data_point))


        # print("{0}: {1}".format(idx, word))

# x0 = np.array(data[::4])
x0 = np.array(data)

pt.figure()
pt.plot(np.real(x0))
pt.plot(np.imag(x0), 'r')

pt.figure()
N=2500
pt.plot(np.arange(-N/2, N/2)/float(N), 20*np.log10(1e-10 + np.abs(np.fft.fftshift(np.fft.fft(x0, N)))))

pt.figure()
pt.plot(np.angle(x0[:-1] * np.conjugate(x0[1:])) / (2 * np.pi))

pt.show()

