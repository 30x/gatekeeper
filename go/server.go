package main
/*
*/
import "C"

import (
    // "log"
    // "os"
    "strings"
    "bytes"
	 "net/http"
   "net/url"
    )

var counter = 0

//export process
func process(uri string, method string, rawHeaders string) (*C.char, *C.char, *C.char){
  //  f,err := os.OpenFile("./ngx_go.log", os.O_RDWR | os.O_CREATE | os.O_APPEND, 0666)
  //  if err != nil {

  //  }
  // defer f.Close()
  // log.SetOutput(f)
  //parse uri
  parsedUri, err := url.Parse(uri)
  if err != nil {
    //log
  }
  headerValues := strings.Split(rawHeaders,"\n")
  headerMap := make(http.Header)
  for _, header := range headerValues  {
    keyValue := strings.Split(header,": ")
    if(len(keyValue) == 2){
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

  }

  //start something with headers
  modifyHeaders(headerMap)
  //end
  var buffer bytes.Buffer
  for key := range headerMap {

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
    val := valuesBuffer.String()
    buffer.WriteString(key)
    buffer.WriteString(": ")
    buffer.WriteString(val)
    buffer.WriteString("\n")
  }
  serializedHeaders := buffer.String()
  // log.Print("headers are ")
  // log.Print( serializedHeaders)

	return C.CString(parsedUri.String()), C.CString(method), C.CString(serializedHeaders)
}
func modifyHeaders(headers http.Header){
  for k := range headers {
    if(strings.Contains(k,"X-MyHeader")){
      for i:=0; i <  len(headers[k]); i++ {
        newVal := "modified" + headers[k][i]
        headers[k][i] = newVal

      }
    }
  }
}
func main() {

}


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