package main

import (
	"fmt"
	"main/core"
	"main/telemetry"
	"os"
)

func main() {
	mode, ok := os.LookupEnv("MODE")

	if !ok {
		fmt.Println("MODE is not set! Defaulting to `dev`!")
		mode = "dev"
	}

	core.LoadConfig(mode)

	tracerShutdown := telemetry.InitTracer()
	defer tracerShutdown()

	r := Init()

	r.Run()
}
