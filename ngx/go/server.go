package main
/*
typedef struct {
    char *a;
    char *b;
} Header;
*/
import "C"

import (
    )

var counter = 0

//export process
func process(method string, headers string, body string) C.Header {
  counter = counter + 1

  var foo =  C.Header{C.CString("1"),C.CString("2")}
	return foo
}

func main() {}
