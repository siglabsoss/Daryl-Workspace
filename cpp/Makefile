CXX=g++

all: udp

udp: main.o udp_server.o
	$(CXX) -o udp main.o udp_server.o

main.o: main.cpp udp_server.h
	$(CXX) -o main.o main.cpp -std=c++11 -c

udp_server.o: udp_server.cpp udp_server.h
	$(CXX) -o udp_server.o udp_server.cpp -std=c++11 -c

clean:
	@rm -f *.o
	@rm -f udp