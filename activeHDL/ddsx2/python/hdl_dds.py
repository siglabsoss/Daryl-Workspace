import os, time
import numpy as np
import matplotlib.pyplot as pt
import jinja2

env = jinja2.Environment(loader=jinja2.FileSystemLoader('templates'))
temp = env.get_template('ddsx2.svt')
temp2 = env.get_template('sincos.svt')
temp3 = env.get_template('lpf_3bit.svt')

def mybin(x, N=36):
    if N == 36:
        if x < 0:
            return '{:036b}'.format(2**N + x)
        else:
            return '{:036b}'.format(x)
    elif N == 32:
        if x < 0:
            return '{:032b}'.format(2**N + x)
        else:
            return '{:032b}'.format(x)
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

lut_width = 9;

fc = 31.5
fs = 250.0

sin_values = [ mybin(int(sk)) for sk in np.round((2**35-1)*np.sin(2*np.pi*np.arange(2.0**lut_width)*(fc/fs))) ]
cos_values = [ mybin(int(ck)) for ck in np.round((2**35-1)*np.cos(2*np.pi*np.arange(2.0**lut_width)*(fc/fs))) ]

pt.figure()
pt.plot([ int(sk) for sk in np.round((2**35-1)*np.cos(2*np.pi*np.arange(2.0**lut_width)*(fc/fs))) ])
pt.plot([ int(sk) for sk in np.round((2**35-1)*np.sin(2*np.pi*np.arange(2.0**lut_width)*(fc/fs))) ], 'r')


def signer(x, N=36):
    if x >= 2**(N-1):
        return -2**N + x
    else:
        return x
##### \ #
# testwave = - 1j*np.array([ int(sk) for sk in np.round((2**35-1)*np.sin(2*np.pi*np.arange(2.0**lut_width)*(31.5/250.0))) ], dtype=np.complex) \
#     + np.array([ int(sk) for sk in np.round((2**35-1)*-np.cos(2*np.pi*np.arange(2.0**lut_width)*(31.5/250.0))) ], dtype=np.complex)
testwave = 1j*np.array([ np.floor(signer(int(sk, base=2)) / 2.0**(36-16)) \
    for sk in sin_values], dtype=np.complex)
testwave += np.array([ np.floor(signer(int(ck, base=2)) / 2.0**(36-16)) \
    for ck in cos_values], dtype=np.complex)
testwave2 = np.zeros(1000, dtype=np.complex)
testwave2[:500] = testwave[:500]
testwave2[500:] = testwave[:500]

pt.figure()
pt.plot(np.arange(-500, 500)/(1000.0), np.abs(np.fft.fftshift(np.fft.fft(testwave2, 1000))))
pt.show()

pt.figure()
pt.plot(np.real(testwave2))
pt.plot(np.imag(testwave2), 'r')
pt.show()

#os.system('rm -f ddsx2.sv')
os.system('del /Q ddsx2.sv')
with open('ddsx2.sv', 'w') as fid:
    print(
        temp.render(
            romname='ddsx2',
            date=time.strftime("%m/%d/%Y"),
            lut_width=lut_width,
            lut_values=np.arange(2**lut_width),
            sin_values=sin_values,
            cos_values=cos_values,
            two_pi=mybin(int((2**13)*2*np.pi), N=16)
        ),
        file=fid)

sincos = []
for sin_value, cos_value in zip(sin_values, cos_values):
    sincos.append('' + sin_value + cos_value)

#os.system('rm -f sincos.mif')
os.system('del /Q sincos.mif')
with open('sincos.mif', 'w') as fid:
    print(
        temp2.render(
            romname='sincos',
            date=time.strftime("%m/%d/%Y"),
            sincos=sincos
        ),
        file=fid)

N, hfilt_bits = 500, 3
hfilt = np.exp(2j*np.pi*(fc/fs)*np.arange(N))
hfilt_re = np.round((2**(hfilt_bits-1)-1)*np.real(hfilt))
hfilt_im = np.round((2**(hfilt_bits-1)-1)*np.imag(hfilt))

delays_re_2bit = []
delays_re_1bit = []
delays_re_m1bit = []
delays_re_m2bit = []
for k, hre in enumerate(hfilt_re):
    if hre == 2 or hre == 3:
        delays_re_2bit.append(k)
    if hre == 1 or hre == 3:
        delays_re_1bit.append(k)
    if hre == -1 or hre == -3:
        delays_re_m1bit.append(k)
    if hre == -2 or hre == -3:
        delays_re_m2bit.append(k)

delays_im_2bit = []
delays_im_1bit = []
delays_im_m1bit = []
delays_im_m2bit = []
for k, hre in enumerate(hfilt_im):
    if hre == 2 or hre == 3:
        delays_im_2bit.append(k)
    if hre == 1 or hre == 3:
        delays_im_1bit.append(k)
    if hre == -1 or hre == -3:
        delays_im_m1bit.append(k)
    if hre == -2 or hre == -3:
        delays_im_m2bit.append(k)

stage_indices = np.arange(np.max([
    int(2 + np.ceil(np.log(c)/np.log(2))) for c in [
        len(delays_re_2bit), len(delays_re_1bit),
        len(delays_re_m1bit), len(delays_re_m2bit),
        len(delays_im_2bit), len(delays_im_1bit),
        len(delays_im_m1bit), len(delays_im_m2bit)]]))

log2_delays_re_2bit = [np.arange(max(1, len(delays_re_2bit)/2**stage)) for stage in stage_indices]
log2_delays_re_1bit = [np.arange(max(1, len(delays_re_1bit)/2**stage)) for stage in stage_indices]
log2_delays_re_m1bit = [np.arange(max(1, len(delays_re_m1bit)/2**stage)) for stage in stage_indices]
log2_delays_re_m2bit = [np.arange(max(1, len(delays_re_m2bit)/2**stage)) for stage in stage_indices]
log2_delays_im_2bit = [np.arange(max(1, len(delays_im_2bit)/2**stage)) for stage in stage_indices]
log2_delays_im_1bit = [np.arange(max(1, len(delays_im_1bit)/2**stage)) for stage in stage_indices]
log2_delays_im_m1bit = [np.arange(max(1, len(delays_im_m1bit)/2**stage)) for stage in stage_indices]
log2_delays_im_m2bit = [np.arange(max(1, len(delays_im_m2bit)/2**stage)) for stage in stage_indices]

#os.system('rm -f lpf_3bit.sv')
os.system('del /Q lpf_3bit.sv')
with open('lpf_3bit.sv', 'w') as fid:
    print(
        temp3.render(
            romname='lpf_3bit',
            date=time.strftime("%m/%d/%Y"),
            delay_indices=np.arange(N),
            delays_re_2bit=delays_re_2bit,
            delays_re_1bit=delays_re_1bit,
            delays_re_m1bit=delays_re_m1bit,
            delays_re_m2bit=delays_re_m2bit,
            delays_im_2bit=delays_im_2bit,
            delays_im_1bit=delays_im_1bit,
            delays_im_m1bit=delays_im_m1bit,
            delays_im_m2bit=delays_im_m2bit,
            log2_delays_re_2bit=log2_delays_re_2bit,
            log2_delays_re_1bit=log2_delays_re_1bit,
            log2_delays_re_m1bit=log2_delays_re_m1bit,
            log2_delays_re_m2bit=log2_delays_re_m2bit,
            log2_delays_im_2bit=log2_delays_im_2bit,
            log2_delays_im_1bit=log2_delays_im_1bit,
            log2_delays_im_m1bit=log2_delays_im_m1bit,
            log2_delays_im_m2bit=log2_delays_im_m2bit,
            stage_indices=stage_indices
        ),
        file=fid)
