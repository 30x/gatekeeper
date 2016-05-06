package main

import "C"

import (
    "log"
    "fmt"
    )

var counter = 0

//export process
func process(uri string, method string, headerKeys []string, headerValues []string) (string, []string, []string){
  counter = counter + 1

  log.Printf("method %s",uri)
  keysLength := len(headerKeys)
  valuesLength := len(headerValues)
  if(valuesLength !=  keysLength){
    fmt.Sprintf("keys %s must must equal values %s ",keysLength,valuesLength)
    return "",[]string{},[]string{}
  }
  length := keysLength
  headers := make(map[string][]string)
  for i:=0; i < length; i++  {
    key := headerKeys[i]
    if _, ok := headers[key] ; !ok{
      headers[key] = make([]string,10)
    }
    headers[key] = append(headers[key],headerValues[i])
    headerValues[i] =  headerValues[i]+"modified"
  }
  //do something with headers
  keys := make([]string,keysLength)
  vals := make([]string,keysLength)

  for k,_:= range headers {
    v := headers[k]
    for _ ,val := range v {
      keys = append(keys,k)
      vals = append(vals,val)
    }
  }

  //kv := C.KeyValue{C.CString("1"),C.CString("2")}

	return uri, keys, vals
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