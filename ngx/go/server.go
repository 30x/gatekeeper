package main

import "C"

import (
    "log"
    "fmt"
    )

var counter = 0

//export process
func process(method string, headerKeys []string, headerValues []string, body string) ([]string, []string){
  counter = counter + 1

  log.Printf("method %s",method)
  log.Printf("body: %s",body)
  keysLength := len(headerKeys)
  valuesLength := len(headerValues)
  if(valuesLength !=  keysLength){
    fmt.Sprintf("keys %s must must equal values %s ",keysLength,valuesLength)
    return []string{},[]string{}
  }
  length := keysLength
  for i:=0; i < length; i++  {
    val := headerValues[i]
    key := headerKeys[i]
    log.Print(fmt.Sprintf("key is %s val is %s",key,val))
  }

  //kv := C.KeyValue{C.CString("1"),C.CString("2")}


	return headerKeys,headerValues
}

func main() {}


/*
typedef struct {
    char **keys
    int keys_length
    char **vals
    char vals_length
} KeyValue;
static char**makeCharArray(int size) {
        return calloc(sizeof(char*), size);
}

static void setArrayString(char **a, int i, char *s) {
        a[i] = KeyValue{};
}
*/