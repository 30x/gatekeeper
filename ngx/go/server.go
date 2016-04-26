package main
/*
typedef struct {
    string a;
    string b;
} Header;
*/
import "C"

import (
    )

var counter = 0

//export process
func process(method string, headers string, body string) C.Header {
  counter = counter + 1
  var foo =  C.Header{1,2}
	return foo
}

func main() {}
