package main
/*
*/
import "C"

import (
    "strings"
    "bytes"
    )

var counter = 0

//export process
func process(uri string, method string, rawHeaders string) (*C.char, *C.char){
  counter = counter + 1
  headerValues := strings.Split(rawHeaders,"\n")
  headerMap := make(map[string][]string)
  for _, header := range headerValues  {
    keyValue := strings.Split(header,": ")
    key := keyValue[0]
    valueString := keyValue[1]
    if valueString != "" {
      values := strings.Split(valueString,",")
      if _, ok := headerMap[key] ; !ok{
        headerMap[key] = make([]string,len(values))
      }
      for i:=0; i < len(values); i++ {
         headerMap[key][i] = values[i]
      }
    }

  }

  //start something with headers
  modifyHeaders(headerMap)
  //end
  var buffer bytes.Buffer
  for key := range headerMap {
    buffer.WriteString(key)
    buffer.WriteString(": ")
    values := headerMap[key]
    var valuesBuffer bytes.Buffer
    for i:=0; i< len(values); i++ {
      if(values[i] != ""){
        if(i > 0){
          valuesBuffer.WriteString(",")
        }
        valuesBuffer.WriteString(values[i])
      }
    }
    buffer.WriteString(valuesBuffer.String())
    buffer.WriteString("\n")
  }
  serializedHeaders := buffer.String()
	return C.CString(uri), C.CString(serializedHeaders)
}
func modifyHeaders(headers map[string][]string){
  for k := range headers {
    for i:=0; i <  len(headers[k]); i++ {
      headers[k][i] =  headers[k][i] + "modified"
    }
  }
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