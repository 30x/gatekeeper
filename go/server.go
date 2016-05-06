package main
/*
*/
import "C"

import (
    "log"
    "strings"
    "bytes"
    )

var counter = 0

//export process
func process(uri string, method string, rawHeaders string) (string, string){
  counter = counter + 1
  headerValues := strings.Split(rawHeaders,"\n")
  headerMap := make(map[string][]string)
  for _,header := range headerValues  {
    keyValue := strings.Split(header,":")
    key := keyValue[0]
    value := keyValue[1]
    if _, ok := headerMap[key] ; !ok{
      headerMap[key] = make([]string,10)
    }
    headerMap[key] = append(headerMap[key], value)
  }

  //start something with headers
  modifyHeaders(headerMap)
  //end
  var buffer bytes.Buffer
  for key := range headerMap {
    buffer.WriteString(key)
    buffer.WriteString(":")
    values := headerMap[key]
    valuesString := strings.Join(values,",")
    buffer.WriteString(valuesString)
    buffer.WriteString("\n")
  }
  serializedHeaders := buffer.String()
  log.Print(serializedHeaders)
	return uri, serializedHeaders
}
func modifyHeaders(headers map[string][]string){
  for k := range headers {
    values := headers[k]
    for _ ,value := range values {
      value = value + "modified"
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