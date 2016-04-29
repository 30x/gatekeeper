package main
/*
typedef struct {
    char *a;
    char *b;
} Header;
typedef struct{
    Header *headers;
} Headers;
*/
import "C"

import (
    "log"
    )

var counter = 0

//export process
func process(method *C.char, headers *C.Headers, body *C.char) C.Header {
  counter = counter + 1
  var m = C.GoString(method)

  var b = C.GoString(body)

  log.Printf(m)
  log.Print(b)

  var foo =  C.Header{C.CString("1"),C.CString("2")}
	return foo
}

func main() {}
