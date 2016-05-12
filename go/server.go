package main

/*
 */
import "C"

import (
	"bytes"
	"log"
	"net/http"
	"net/url"
	"os"
	"strings"
)

//LogInfo the info log level
var LogInfo = log.New(os.Stdout, "INFO: ", log.Ldate|log.Ltime|log.LUTC|log.Lshortfile)

//LogWarn the warn log level
var LogWarn = log.New(os.Stdout, "WARN: ", log.Ldate|log.Ltime|log.LUTC|log.Lshortfile)

//LogError the error log level
var LogError = log.New(os.Stdout, "ERROR: ", log.Ldate|log.Ltime|log.LUTC|log.Lshortfile)

//export onRequest
func onRequest(uri string, method string, rawHeaders string) (*C.char, *C.char, *C.char) {
	//parse uri
	parsedUri, err := url.Parse(uri)
	if err != nil {
		LogError.Print(err)
	}
	headerMap := make(http.Header)
	parseHeaders(headerMap, rawHeaders)

	//start something with headers
	modifyHeaders(headerMap)
	//end

	//serialize map back to string
	serializedHeaders := serializeHeaders(headerMap)

	return C.CString(parsedUri.String()), C.CString(method), C.CString(serializedHeaders)
}

//export onResponse
func onResponse(uri string, method string, requestHeaders string, responseHeaders string) (*C.char){

  responseHeaderMap := make(http.Header)
  requestHeaderMap := make(http.Header)

	parseHeaders(responseHeaderMap, responseHeaders)
	parseHeaders(requestHeaderMap, requestHeaders)

  //start something with headers
	responseHeaderMap.Add("X-response-newheader","mytestval1");
	//end

	//serialize map back to string
	serializedHeaders := serializeHeaders(responseHeaderMap);
  return C.CString(serializedHeaders)
}

//modify the header map, placeholder for plugins
func modifyHeaders(headerMap http.Header) {
	for k := range headerMap {
		if strings.Contains(k, "X-MyHeader") {
			for i := 0; i < len(headerMap[k]); i++ {
				newVal := "modified" + headerMap[k][i]
				headerMap[k][i] = newVal

			}
		}
	}
}

//serialize the headersMap back to a string
func serializeHeaders(headerMap http.Header) string {
	var buffer bytes.Buffer
	for key := range headerMap {
		values := headerMap[key]
		var valuesBuffer bytes.Buffer
		for i := 0; i < len(values); i++ {
			if values[i] != "" {
				if i > 0 {
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

	return serializedHeaders
}

//parse rawHeaders back into a map
func parseHeaders(headerMap http.Header, rawHeaders string) {
	headerValues := strings.Split(rawHeaders, "\n")
	for _, header := range headerValues {
		keyValue := strings.Split(header, ": ")
		if len(keyValue) == 2 {
			key := keyValue[0]
			valueString := keyValue[1]
			if valueString != "" {
				values := strings.Split(valueString, ",")
				if _, ok := headerMap[key]; !ok {
					headerMap[key] = make([]string, len(values))
				}
				for i := 0; i < len(values); i++ {
					headerMap[key][i] = values[i]
				}
			}
		}

	}
}
func main() {

}
