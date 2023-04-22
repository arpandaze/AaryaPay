package main

import (
	"main/core"

	"main/telemetry"
)

func main() {
	core.LoadConfig("dev")

	tracerShutdown := telemetry.InitTracer()
	defer tracerShutdown()

	r := Init()

	r.Run()
}
