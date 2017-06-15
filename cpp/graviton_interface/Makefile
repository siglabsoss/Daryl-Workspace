CXX=g++
WARNINGS=-Wall -Wextra -pedantic
THREAD=-pthread

all: recvonly loopback graviton

graviton: graviton.o txrxl.o repl.o udp_receiver.o udp_transmitter.o
	$(CXX) $(THREAD) -o graviton graviton.o txrxl.o repl.o udp_receiver.o udp_transmitter.o

recvonly: recvonly.o udp_receiver.o
	$(CXX) $(THREAD) -o recvonly recvonly.o udp_receiver.o

loopback: loopback.o udp_receiver.o udp_transmitter.o
	$(CXX) $(THREAD)  -o loopback loopback.o udp_receiver.o udp_transmitter.o

graviton.o: graviton.cpp udp_receiver.h udp_transmitter.h gthreads.h
	$(CXX) $(WARNINGS) -o graviton.o graviton.cpp -std=c++11 -c

txrxl.o: txrxl.cpp udp_receiver.h udp_transmitter.h gthreads.h
	$(CXX) $(WARNINGS) -o txrxl.o txrxl.cpp -std=c++11 -c

repl.o: repl.cpp udp_receiver.h udp_transmitter.h gthreads.h
	$(CXX) $(WARNINGS) -o repl.o repl.cpp -std=c++11 -c

recvonly.o: recvonly.cpp udp_receiver.h
	$(CXX) $(WARNINGS) -o recvonly.o recvonly.cpp -std=c++11 -c

loopback.o: loopback.cpp udp_receiver.h udp_transmitter.h
	$(CXX) $(WARNINGS) -o loopback.o loopback.cpp -std=c++11 -c

udp_receiver.o: udp_receiver.cpp udp_receiver.h
	$(CXX) $(WARNINGS) -o udp_receiver.o udp_receiver.cpp -std=c++11 -c

udp_transmitter.o: udp_transmitter.cpp udp_transmitter.h
	$(CXX) $(WARNINGS) -o udp_transmitter.o udp_transmitter.cpp -std=c++11 -c

clean:
	@rm -f *.o
	@rm -f recvonly
	@rm -f loopback
	@rm -f graviton
