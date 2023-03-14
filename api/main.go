package main

import (
	"main/core"
)

func main() {
	tracerShutdown := core.InitTracer()
	defer tracerShutdown()

	r := Init()
	
	r.Run()
}
