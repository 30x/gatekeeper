BASEPATH   := $(strip $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST)))))
VENDORPATH := $(BASEPATH)/vendor
LIBGOZPATH := $(VENDORPATH)/github.com/30x/libgozerian
PLUGINS    := $(BASEPATH)/plugins/*
	
all: lua libgozerian

lua:
	wget -N -P lua https://github.com/30x/lua-gozerian/archive/master.zip
	unzip -o -j lua/master.zip lua-gozerian-master/lib/resty/gozerian/* -d lua
	rm lua/master.zip

libgozerian:	
	# rm -rf $(GOPATH)/src/github.com/30x/goz-verify-api-key/vendor
	glide install

	cp $(PLUGINS) $(LIBGOZPATH)
	cd $(LIBGOZPATH) && make clean && make
	cp $(LIBGOZPATH)/libgozerian.so $(BASEPATH)

clean:
	rm -rf vendor
	rm -rf build
	rm -rf lua
	-rm libgozerian.so
	
.PHONY: clean
