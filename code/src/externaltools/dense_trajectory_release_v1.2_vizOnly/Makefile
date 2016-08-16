# set the binaries that have to be built
TARGETS := DenseTrack Video

# set the build configuration set 
BUILD := release
#BUILD := debug

# set bin and build dirs
BUILDDIR := .build_$(BUILD)
BINDIR := $(BUILD)

# libraries 
LDLIBS = $(addprefix -l, $(LIBS) $(LIBS_$(notdir $*)))
LIBS := \
	opencv_core opencv_highgui opencv_video opencv_imgproc \
	avformat avutil avcodec swscale # avdevice 

# set some flags and compiler/linker specific commands
# CXXFLAGS = -pipe -D __STDC_CONSTANT_MACROS -D STD=std -Wall $(CXXFLAGS_$(BUILD)) -I. -I/opt/include -I/IUS/vmr101/software/ubuntu12.04/opencv-2.4.5/include # Yell
CXXFLAGS = -pipe -D __STDC_CONSTANT_MACROS -D STD=std -Wall $(CXXFLAGS_$(BUILD)) -I. \
-I/opt/include \
-I/home/nrhineha/lib/opencv2.4/include/ \
-I/home/nrhineha/lib/opencv-2.4/include/opencv/ \
-I/home/nrhineha/lib/opencv-2.4/include/ # Speedy3; -I/opt/ros/groovy/include/opencv/ 
CXXFLAGS_debug := -ggdb
CXXFLAGS_release := -O3 -DNDEBUG -ggdb

LDFLAGS_debug := -ggdb
LDFLAGS_release := -O3 -ggdb
#LDFLAGS =  -pipe -Wall $(LDFLAGS_$(BUILD)) -L/IUS/vmr101/software/ubuntu12.04/opencv-2.4.5/lib # Yell
#LDFLAGS =  -pipe -Wall $(LDFLAGS_$(BUILD)) -L/opt/ros/groovy/lib # Speedy3
LDFLAGS =  -pipe -Wall $(LDFLAGS_$(BUILD)) -L/home/nrhineha/lib/opencv2.4/lib/ # Speedy3

include make/generic.mk
