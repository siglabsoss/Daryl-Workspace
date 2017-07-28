import numpy as np
import matplotlib.pyplot as pt

def polyphase(N, M):
	if N % 2 == 0:
		xp = np.exp(-1j*np.pi*np.arange(N)**2/N)
	else:
		xp = np.exp(-1j*np.pi*np.arange(N)*np.arange(1, N+1)/N)
	return np.tile(xp, M)

N, M = 20, 10
x = polyphase(N, M+2)
x[:N], x[-N:] = 0.0, 0.0

sigma = 0.1
delta_f = 0.015

w = sigma * (np.random.standard_normal(x.size) + 1j*np.random.standard_normal(x.size))
y = x * np.exp(2j*np.pi*delta_f*np.arange(x.size)) + w

pt.figure()
pt.subplot(211)
pt.plot(np.real(x))
pt.plot(np.imag(x), 'g')
pt.subplot(212)
pt.plot(np.real(y))
pt.plot(np.imag(y), 'g')

Ayy1 = np.conj(y[:-N]) * y[N:]
Ayy2 = np.conj(y[:-2*N]) * y[2*N:]
Ayy3 = np.conj(y[:-3*N]) * y[3*N:]
Ayy4 = np.conj(y[:-4*N]) * y[4*N:]

pt.figure()
pt.plot(np.abs(Ayy1))
pt.plot(np.abs(Ayy2), 'g')
pt.plot(np.abs(Ayy3), 'r')
pt.plot(np.abs(Ayy4), 'k')

pt.figure()
pt.plot(np.angle(Ayy1)/(2*np.pi*N))
pt.plot(np.angle(Ayy2)/(2*np.pi*2*N), 'g')
pt.plot(np.angle(Ayy3)/(2*np.pi*3*N), 'r')
pt.plot(np.angle(Ayy4)/(2*np.pi*4*N), 'k')

phi1 = np.angle(np.mean(Ayy1[25:135]))/(2*np.pi*N)
phi2 = np.angle(np.mean(Ayy2[25:135]))/(2*np.pi*2*N)
phi3 = np.angle(np.mean(Ayy3[25:135]))/(2*np.pi*3*N)
phi4 = np.angle(np.mean(Ayy4[25:135]))/(2*np.pi*4*N)
phi = np.array([phi1, phi2, phi3, phi4])

print("phi >>")
print(phi)

D = 1.0

X = np.array([[1,0,0,0],[1.0/2.0,-D,0,0],[1.0/3.0,0,-D/2,0],[1.0/4.0,0,0,-D/4]])
d = np.linalg.lstsq(X, phi)[0]
d[1:] = np.round(d[1:])

print("d >>")
print(d)

d2 = np.dot(X, d)

print("d2 >>")
print(d2)
pt.show()
