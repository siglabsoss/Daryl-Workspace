CXX=g++
THREAD=-pthread

all: recvonly loopback

recvonly: recvonly.o udp_receiver.o
	$(CXX) $(THREAD) -o recvonly recvonly.o udp_receiver.o

loopback: loopback.o udp_receiver.o udp_transmitter.o
	$(CXX) $(THREAD)  -o loopback loopback.o udp_receiver.o udp_transmitter.o

loopback.o: loopback.cpp udp_receiver.h udp_transmitter.h
	$(CXX) -o loopback.o loopback.cpp -std=c++11 -c

recvonly.o: recvonly.cpp udp_receiver.h
	$(CXX) -o recvonly.o recvonly.cpp -std=c++11 -c

udp_receiver.o: udp_receiver.cpp udp_receiver.h
	$(CXX) -o udp_receiver.o udp_receiver.cpp -std=c++11 -c

udp_transmitter.o: udp_transmitter.cpp udp_transmitter.h
	$(CXX) -o udp_transmitter.o udp_transmitter.cpp -std=c++11 -c

clean:
	@rm -f *.o
	@rm -f recvonly
	@rm -f loopback
