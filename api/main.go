package main

import (
	"main/core"
	"main/telemetry"
)

func main() {
	core.LoadConfig()

	tracerShutdown := telemetry.InitTracer(core.Configs.TEMPO_ADDRESS(), core.Configs.SERVER_NAME)
	defer tracerShutdown()

	r := Init()

	r.Run(core.Configs.PORT_STUB())

	defer core.DB.Close()
}
