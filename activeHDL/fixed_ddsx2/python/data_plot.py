import numpy as np
import matplotlib.pyplot as pt

samps = []
# with open('../outvec.txt') as fid:
with open('outvec.txt') as fid:
    for line in fid:
        real_part, imag_part = line.split(',')
        if (real_part.strip() != 'x'):
            real_part, imag_part = int(real_part), int(imag_part)
            real_part, imag_part = float(real_part), float(imag_part)
            samps.append(real_part + 1j*imag_part)
samps = np.array(samps)

# TODO: Add this filter to purify the tone
N, hfilt_bits = 64, 3
hfilt = np.exp(2j*np.pi*31.5/250.0*np.arange(N))
hfilt_re = np.round((2**(hfilt_bits-1)-1)*np.real(hfilt))/(2**(hfilt_bits-1)-1)
hfilt_im = np.round((2**(hfilt_bits-1)-1)*np.imag(hfilt))/(2**(hfilt_bits-1)-1)
hfilt = hfilt_re + 1j*hfilt_im
samps = np.convolve(samps, hfilt) / N
samps = 0.9594 * np.convolve(samps, hfilt) / N

print('3-valued: {0}, {1}'.format(np.sum((2**(hfilt_bits-1)-1)*hfilt_re == 3), np.sum((2**(hfilt_bits-1)-1)*hfilt_im == 3)))
print('2-valued: {0}, {1}'.format(np.sum((2**(hfilt_bits-1)-1)*hfilt_re == 2), np.sum((2**(hfilt_bits-1)-1)*hfilt_im == 2)))
print('1-valued: {0}, {1}'.format(np.sum((2**(hfilt_bits-1)-1)*hfilt_re == 1), np.sum((2**(hfilt_bits-1)-1)*hfilt_im == 1)))
print('0-valued: {0}, {1}'.format(np.sum((2**(hfilt_bits-1)-1)*hfilt_re == 0), np.sum((2**(hfilt_bits-1)-1)*hfilt_im == 0)))
print('-1-valued: {0}, {1}'.format(np.sum((2**(hfilt_bits-1)-1)*hfilt_re == -1), np.sum((2**(hfilt_bits-1)-1)*hfilt_im == -1)))
print('-2-valued: {0}, {1}'.format(np.sum((2**(hfilt_bits-1)-1)*hfilt_re == -2), np.sum((2**(hfilt_bits-1)-1)*hfilt_im == -2)))
print('-3-valued: {0}, {1}'.format(np.sum((2**(hfilt_bits-1)-1)*hfilt_re == -3), np.sum((2**(hfilt_bits-1)-1)*hfilt_im == -3)))

print('DC Gain = {0}'.format((2**(hfilt_bits-1)-1)*np.sum(hfilt)))

pt.figure()
pt.plot((2**(hfilt_bits-1)-1) * hfilt_re)
pt.plot((2**(hfilt_bits-1)-1) * hfilt_im, 'g')

pt.figure()
pt.plot(250*np.arange(-8*8192, 8*8192)/(16.0*8192), 20*np.log10(np.fft.fftshift(np.fft.fft(hfilt, 16*8192))))

samps = samps[1000::]
expected = 2**35*np.exp(2j * np.pi * (31.5/250.0) * np.arange(samps.size));

pt.figure()
pt.subplot(2,1,1)
pt.plot(np.real(samps[:min(10000, samps.size)]))
pt.plot(np.real(expected[:min(10000, samps.size)]), 'g-.')
pt.title('Real part (integer-valued)')
pt.subplot(2,1,2)
pt.plot(np.imag(samps[:min(10000, samps.size)]))
pt.plot(np.imag(expected[:min(10000, samps.size)]), 'g-.')
pt.title('Imag part (integer-valued)')

# freq_samps = (2**-35)*np.fft.fftshift(np.fft.fft(samps, 16*8192))
# freq_expected = (2**-35)*np.fft.fftshift(np.fft.fft(expected, 16*8192))
freq_samps = (2**-35)*np.fft.fftshift(np.fft.fft(samps, 31500))
freq_expected = (2**-35)*np.fft.fftshift(np.fft.fft(expected, 31500))
pt.figure()
# pt.plot(250*np.arange(-8*8192, 8*8192)/(16.0*8192), 20*np.log10(np.abs(freq_samps)))
# pt.plot(250*np.arange(-8*8192, 8*8192)/(16.0*8192), 20*np.log10(np.abs(freq_expected)), 'g')
pt.plot(250*np.arange(-31500/2, 31500/2)/(31500.0), 20*np.log10(np.abs(freq_samps)))
pt.plot(250*np.arange(-31500/2, 31500/2)/(31500.0), 20*np.log10(np.abs(freq_expected)), 'g')
pt.xlim(250*np.array([-0.5, 0.5]))
pt.xlabel('Frequency (MHz)')
pt.ylabel('Raw Magnitude (dB)')

pt.show()
