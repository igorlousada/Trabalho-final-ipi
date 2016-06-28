all: djikstra.o djikstra2.o

%.o: %.cpp
	mex -largeArrayDims $< -output $@
