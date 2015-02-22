DL_NAME := gloptipoly3.tar.gz
DL_PATH := http://homepages.laas.fr/henrion/software/gloptipoly3
UNZIP_DIR := gloptipoly3

default_target: all

# Figure out where to build the software.
#   Use BUILD_PREFIX if it was passed in.
#   If not, search up to four parent directories for a 'build' directory.
#   Otherwise, use ./build.
ifeq "$(BUILD_PREFIX)" ""
BUILD_PREFIX:=$(shell for pfx in ./ .. ../.. ../../.. ../../../..; do d=`pwd`/$$pfx/build;\
               if [ -d $$d ]; then echo $$d; exit 0; fi; done; echo `pwd`/build)
endif
# create the build directory if needed, and normalize its path name
BUILD_PREFIX:=$(shell mkdir -p $(BUILD_PREFIX) && cd $(BUILD_PREFIX) && echo `pwd`)

# Default to a release build.  If you want to enable debugging flags, run
# "make BUILD_TYPE=Debug"
ifeq "$(BUILD_TYPE)" ""
BUILD_TYPE="Release"
endif

all: $(UNZIP_DIR) $(BUILD_PREFIX)/matlab/addpath_gloptipoly3.m $(BUILD_PREFIX)/matlab/rmpath_gloptipoly3.m

$(UNZIP_DIR):
	@echo "\nDownloading gloptipoly3 \n\n"
	wget --no-check-certificate $(DL_PATH)/$(DL_NAME)
	@echo "\nunzipping to $(UNZIP_DIR) \n\n"
	tar -xzvf $(DL_NAME) && rm $(DL_NAME)
	@echo "\nBUILD_PREFIX: $(BUILD_PREFIX)\n\n"

$(BUILD_PREFIX)/matlab/addpath_gloptipoly3.m :
	@mkdir -p $(BUILD_PREFIX)/matlab
	echo "Writing $(BUILD_PREFIX)/matlab/addpath_gloptipoly3.m"
	echo "function addpath_gloptipoly3()\n\n \
	  root = fullfile('$(shell pwd)','gloptipoly3');\n \
		addpath(fullfile(root));\n \
		end\n \
		\n" \
		> $(BUILD_PREFIX)/matlab/addpath_gloptipoly3.m

$(BUILD_PREFIX)/matlab/rmpath_gloptipoly3.m :
	@mkdir -p $(BUILD_PREFIX)/matlab
	echo "Writing $(BUILD_PREFIX)/matlab/rmpath_gloptipoly3.m"
	echo "function rmpath_gloptipoly3()\n\n \
		root = fullfile('$(shell pwd)','gloptipoly3');\n \
		addpath(fullfile(root));\n \
		end\n \
		\n" \
		> $(BUILD_PREFIX)/matlab/rmpath_gloptipoly3.m

clean:
	
	-if [ -e $(BUILD_PREFIX)/matlab/addpath_gloptipoly3.m ]; then echo "Deleting $(BUILD_PREFIX)/matlab/addpath_gloptipoly3.m" && rm $(BUILD_PREFIX)/matlab/addpath_gloptipoly3.m; fi
	-if [ -e $(BUILD_PREFIX)/matlab/rmpath_gloptipoly3.m ]; then echo "Deleting $(BUILD_PREFIX)/matlab/rmpath_gloptipoly3.m" && rm $(BUILD_PREFIX)/matlab/rmpath_gloptipoly3.m; fi
	-if [ -d $(UNZIP_DIR) ]; then echo "Deleting gloptipoly3 unzip directory" && rm -rf $(UNZIP_DIR); fi

# Default to a less-verbose build.  If you want all the gory compiler output,
# run "make VERBOSE=1"
$(VERBOSE).SILENT:
