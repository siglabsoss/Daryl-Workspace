import numpy as np
import matplotlib.pyplot as pt

freqs, phases, mags, phases2, mags2 = [], [], [], [], []
with open('test5.txt') as fid:
    for line in fid:
        fields = line.split(',')
        freqs.append(float(fields[0]))
        mags.append(float(fields[1]))
        phases.append(float(fields[2]))
        mags2.append(float(fields[3]))
        phases2.append(float(fields[4]))
freqs = np.array(freqs)
phases = np.array(phases)
mags = np.array(mags)
phases2 = np.array(phases2)
mags2 = np.array(mags2)

pt.figure()
pt.subplot(2,1,1)
pt.title('Magnitudes')
pt.plot(313*freqs, 20*np.log10(mags/np.max(mags)))
pt.xlabel('CIC output')
pt.xlim([-0.5,0.5])
pt.subplot(2,1,2)
pt.plot(313*freqs, 20*np.log10(mags2/np.max(mags2)))
pt.xlabel('CIC compensated')
pt.xlim([-0.5,0.5])

pt.figure()
pt.subplot(2,1,1)
pt.title('Phases')
pt.plot(313*freqs, phases)
pt.xlabel('CIC output')
pt.xlim([-0.5,0.5])
pt.subplot(2,1,2)
pt.plot(313*freqs, phases2)
pt.xlabel('CIC compensated')
pt.xlim([-0.5,0.5])

pt.show()
