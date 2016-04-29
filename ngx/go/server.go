package main
/*
typedef struct {
    char *key;
    char *val;
} KeyValue;

*/
import "C"

import (
    "unsafe"
    "log"
    )

var counter = 0

//export process
func process(method *C.char, headers *C.KeyValue, headersLength C.int, body *C.char) C.KeyValue {
  counter = counter + 1
  var m = C.GoString(method)
  var b = C.GoString(body)

  log.Printf("method")
  log.Printf(m)
  log.Printf("body")
  log.Print(b)
  log.Printf("size is ")
  headersPtr := unsafe.Pointer(headers)
  slice := (*[1 << 30]C.KeyValue)(headersPtr)[:headersLength:headersLength]
  log.Println("len:", len(slice))
  var foo =  C.KeyValue{C.CString("1"),C.CString("2")}
	return foo
}

func main() {}
