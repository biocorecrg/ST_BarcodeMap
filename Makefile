DIR_INC := ./inc ./src
DIR_SRC := ./src
DIR_OBJ := ./obj

PREFIX ?= /usr/local
BINDIR ?= $(PREFIX)/bin

# Auto-detect HDF5 paths on Debian/Ubuntu if not explicitly provided
DEB_HOST_MULTIARCH ?= $(shell dpkg-architecture -qDEB_HOST_MULTIARCH 2>/dev/null)
HDF5_INC ?= $(shell test -d /usr/include/hdf5/serial && echo "/usr/include/hdf5/serial")
HDF5_LIB ?= $(shell test -n "$(DEB_HOST_MULTIARCH)" && test -d "/usr/lib/$(DEB_HOST_MULTIARCH)/hdf5/serial" && echo "/usr/lib/$(DEB_HOST_MULTIARCH)/hdf5/serial")

INCLUDE_DIRS ?= $(HDF5_INC)
LIBRARY_DIRS ?= $(HDF5_LIB)

SRC := $(wildcard ${DIR_SRC}/*.cpp)
OBJ := $(patsubst %.cpp,${DIR_OBJ}/%.o,$(notdir ${SRC}))

TARGET := ST_BarcodeMap-0.0.1

BIN_TARGET := ${TARGET}

CXX ?= g++
CXXFLAGS := -std=c++11 -g -O3 $(foreach includedir,${DIR_INC} $(INCLUDE_DIRS),-I$(includedir)) ${CXXFLAGS}
LIBS := -lz -lpthread -lboost_serialization -lhdf5
LD_FLAGS := $(foreach librarydir,$(LIBRARY_DIRS),-L$(librarydir)) $(LIBS) $(LD_FLAGS)

.PHONY: all clean install make_obj_dir

all: ${BIN_TARGET}

${BIN_TARGET}:${OBJ}
	$(CXX) $(OBJ) -o $@ $(LD_FLAGS)

${DIR_OBJ}/%.o:${DIR_SRC}/%.cpp make_obj_dir
	$(CXX) -c $< -o $@ $(CXXFLAGS)

clean:
	rm -rf $(DIR_OBJ)
	rm -f $(TARGET)

make_obj_dir:
	@if test ! -d $(DIR_OBJ) ; \
	then \
		mkdir -p $(DIR_OBJ) ; \
	fi

install: ${BIN_TARGET}
	install -d $(BINDIR)
	install $(TARGET) $(BINDIR)/$(TARGET)
	ln -sf $(TARGET) $(BINDIR)/ST_BarcodeMap
	@echo "Installed."
