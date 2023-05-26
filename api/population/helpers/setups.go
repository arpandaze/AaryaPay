package population

import (
	"main/core"
	"main/telemetry"
	"net/http"
	"net/http/httptest"

	ginzap "github.com/gin-contrib/zap"
	"github.com/gin-gonic/gin"
	"go.opentelemetry.io/contrib/instrumentation/github.com/gin-gonic/gin/otelgin"
)

func PopulationInit() (*gin.Engine, *gin.Context, *httptest.ResponseRecorder) {
	tracerShutdown := telemetry.InitTestTracer()
	defer tracerShutdown()

	r := initPopulationRouter()
	w := initPopulationRecorder()
	c := initPopulationContext(w, r)

	return r, c, w
}

func initPopulationRouter() *gin.Engine {
	gin.SetMode(gin.TestMode)

	core.LoadConfig()
	core.ConnectDatabase()
	core.ConnectRedis()

	router := gin.New()
	router.Use(otelgin.Middleware("aaryapay"))

	router.Use(telemetry.GinzapInstance)
	router.Use(ginzap.RecoveryWithZap(telemetry.Logger(nil), true))

	return router
}

func initPopulationRecorder() *httptest.ResponseRecorder {
	return httptest.NewRecorder()
}

func initPopulationContext(w *httptest.ResponseRecorder, r *gin.Engine) *gin.Context {
	c := gin.CreateTestContextOnly(w, r)
	c.Request = &http.Request{}

	return c
}
