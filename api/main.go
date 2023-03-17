package main

import (
	"main/telemetry"
)

func main() {
	tracerShutdown := telemetry.InitTracer()
	defer tracerShutdown()

	r := Init()

	r.Run()
}
