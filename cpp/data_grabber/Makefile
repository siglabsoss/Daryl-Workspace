CXX=clang++

all: udp

udp: main.o udp_receiver.o
	$(CXX) -o udp main.o udp_receiver.o

main.o: main.cpp udp_receiver.h
	$(CXX) -o main.o main.cpp -std=c++11 -c

udp_server.o: udp_receiver.cpp udp_receiver.h
	$(CXX) -o udp_receiver.o udp_receiver.cpp -std=c++11 -c

clean:
	@rm -f *.o
	@rm -f udp
