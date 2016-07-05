package main

import (
	"github.com/30x/gozerian/pipeline"
	"github.com/30x/gozerian/test_util"
	"github.com/30x/goz-verify-api-key/plugin"
)

func init() {
	pipeline.RegisterDie("dump", test_util.CreateDumpFitting)
	pipeline.RegisterDie("verifyAPIKey", plugin.CreateFitting)
}
