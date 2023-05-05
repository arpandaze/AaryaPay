package tests

import (
	"main/core"
	"main/telemetry"
	"net/http"
	"net/http/httptest"
	"os"

	ginzap "github.com/gin-contrib/zap"
	"github.com/gin-gonic/gin"
	"go.opentelemetry.io/contrib/instrumentation/github.com/gin-gonic/gin/otelgin"
)

func TestInit() (*gin.Engine, *gin.Context, *httptest.ResponseRecorder) {
	tracerShutdown := telemetry.InitTracer()
	defer tracerShutdown()

	// core.DB.Exec("DELETE * FROM users")
	// core.DB.Exec("DELETE * FROM users")

	r := initTestRouter()
	w := initTestRecorder()
	c := initTestContext(w, r)

	return r, c, w
}

func initTestRouter() *gin.Engine {
	gin.SetMode(gin.TestMode)

	mode, _ := os.LookupEnv("MODE")

	if mode != "ci-test" {
		mode = "test"
	}

	core.LoadConfigWithMode(mode)
	core.ConnectDatabase()
	core.ConnectRedis()

	router := gin.New()
	router.Use(otelgin.Middleware("aaryapay"))

	router.Use(telemetry.GinzapInstance)
	router.Use(ginzap.RecoveryWithZap(telemetry.Logger(nil), true))

	return router
}

func initTestRecorder() *httptest.ResponseRecorder {
	return httptest.NewRecorder()
}

func initTestContext(w *httptest.ResponseRecorder, r *gin.Engine) *gin.Context {
	c := gin.CreateTestContextOnly(w, r)
	c.Request = &http.Request{}

	return c
}
