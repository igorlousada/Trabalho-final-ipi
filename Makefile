all: djikstra.o

%.o: %.cpp
	mex -largeArrayDims $< -output $@
