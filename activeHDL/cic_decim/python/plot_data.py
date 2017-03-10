import numpy as np
import matplotlib.pyplot as pt

n = np.arange(4000) - 4
gain = (313*2)**5

samps = []
with open('test3.txt') as fid:
    for line in fid:
        real_part, imag_part = line.split(',')
        if (real_part.strip() != 'x'):
            real_part, imag_part = int(real_part), int(imag_part)
            real_part, imag_part = float(real_part), float(imag_part)
            samps.append(real_part + 1j*imag_part)
t3 = np.array(samps)
t3 /= np.max(np.abs(t3))
e3 = ((2.0**(16-1) - 1) * np.exp(2.0j*np.pi*313.0*0.0001*n))
e3 *= gain
e3 /= np.max(np.abs(e3))

pt.figure()
pt.subplot(3,1,1)
pt.plot(np.real(t3))
pt.plot(np.imag(t3))
pt.subplot(3,1,2)
pt.plot(np.real(e3))
pt.plot(np.imag(e3))
pt.subplot(3,1,3)
pt.plot(np.arange(100,4000), np.real(e3[100:] - t3[100:]))
pt.plot(np.arange(100,4000), np.imag(e3[100:] - t3[100:]))
pt.plot(np.arange(100,4000), np.abs(e3[100:] - t3[100:]), 'k')
pt.plot(np.arange(100,4000), -np.abs(e3[100:] - t3[100:]), 'k')

# Report the aliased amplitude
a3b = e3[100:] - t3[100:]
mu_a3b = np.mean(np.abs(a3b))
aliased_amplitude = 20*np.log10(np.mean(np.abs(a3b) - mu_a3b))
expected_amplitude = 20*np.log10(np.mean(np.abs(e3[100:])))
print('expected_amplitude = {0} dB'.format(expected_amplitude))
print('aliased_amplitude = {0} dB'.format(aliased_amplitude))
print('aliased_amplitude = {0} dB down'.format(expected_amplitude - aliased_amplitude))
print('offset of aliased amplitude = {0} linear'.format(mu_a3b))
print('offset of aliased amplitude = {0} dB'.format(20*np.log10(np.abs(mu_a3b))))
samps = []
with open('test4.txt') as fid:
    for line in fid:
        real_part, imag_part = line.split(',')
        if (real_part.strip() != 'x'):
            real_part, imag_part = int(real_part), int(imag_part)
            real_part, imag_part = float(real_part), float(imag_part)
            samps.append(real_part + 1j*imag_part)
t4 = np.array(samps)
e4 = ((2.0**(16-1) - 1) * np.exp(2.0j*np.pi*313.0*0.00001*n)) \
    + ((2.0**(16-2) - 1) * np.exp(2.0j*np.pi*313.0*0.00002*n)) \
    + ((2.0**(16-3) - 1) * np.exp(2.0j*np.pi*313.0*0.00003*n)) \
    + ((2.0**(16-4) - 1) * np.exp(2.0j*np.pi*313.0*0.00004*n)) \
    + ((2.0**(16-5) - 1) * np.exp(2.0j*np.pi*313.0*0.00005*n))
e4 *= gain

pt.figure()
pt.subplot(3,1,1)
pt.plot(np.real(t4))
pt.plot(np.imag(t4))
pt.subplot(3,1,2)
pt.plot(np.real(e4))
pt.plot(np.imag(e4))
pt.subplot(3,1,3)
pt.plot(np.arange(100,4000), np.abs(e4[100:] - t4[100:]))

pt.figure()
pt.subplot(2,1,1)
T3 = np.fft.fftshift(np.fft.fft(t3[100:], 10000))
pt.plot(np.real(T3))
pt.plot(np.imag(T3))
pt.subplot(2,1,2)
E3 = np.fft.fftshift(np.fft.fft(e3[100:], 10000))
pt.plot(np.real(E3))
pt.plot(np.imag(E3))

pt.figure()
pt.subplot(2,1,1)
T4 = np.fft.fftshift(np.fft.fft(t4, 100000))
pt.plot(np.real(T4))
pt.plot(np.imag(T4))
pt.subplot(2,1,2)
E4 = np.fft.fftshift(np.fft.fft(e4, 100000))
pt.plot(np.real(E4))
pt.plot(np.imag(E4))

samps = []
with open('input_vec.txt') as fid:
    for line in fid:
        real_part, imag_part = line.split(',')
        if (real_part.strip() != 'x'):
            real_part, imag_part = int(real_part), int(imag_part)
            real_part, imag_part = float(real_part), float(imag_part)
            samps.append(real_part + 1j*imag_part)
t5 = np.array(samps)

pt.figure()
pt.plot(np.real(t5))
pt.plot(np.imag(t5))

pt.figure()
T5 = np.fft.fftshift(np.fft.fft(t5, 100000))
pt.plot(np.real(T5))
pt.plot(np.imag(T5))

pt.show()
