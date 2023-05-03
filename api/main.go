package main

import (
	"main/core"
	"main/telemetry"
)

func main() {
	core.LoadConfig()

	tracerShutdown := telemetry.InitTracer()
	defer tracerShutdown()


	r := Init()

	r.Run(core.Configs.PORT_STUB())
}
