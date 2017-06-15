CXX=clang++

all: udp loopback

udp: main.o udp_receiver.o
	$(CXX) -o udp main.o udp_receiver.o

loopback: loopback.o udp_receiver.o udp_transmitter.o
	$(CXX) -o loopback loopback.o udp_receiver.o udp_transmitter.o

loopback.o: loopback.cpp udp_receiver.h udp_transmitter.h
	$(CXX) -o loopback.o loopback.cpp -std=c++11 -c

main.o: main.cpp udp_receiver.h
	$(CXX) -o main.o main.cpp -std=c++11 -c

udp_receiver.o: udp_receiver.cpp udp_receiver.h
	$(CXX) -o udp_receiver.o udp_receiver.cpp -std=c++11 -c

udp_transmitter.o: udp_transmitter.cpp udp_transmitter.h
	$(CXX) -o udp_transmitter.o udp_transmitter.cpp -std=c++11 -c

clean:
	@rm -f *.o
	@rm -f udp
	@rm -f loopback
