package endpoints

import (
	auth "main/endpoints/auth"
	favorites "main/endpoints/favorites"
	"main/endpoints/tools"
	transaction "main/endpoints/transaction"

	"github.com/gin-gonic/gin"
)

func InitAuthRoutes(routeGroup *gin.RouterGroup) {

	register := new(auth.RegisterController)
	login := new(auth.LoginController)

	password_recovery := new(auth.PasswordRecoveryController)
	password_change := new(auth.PasswordChangeController)
	verify := new(auth.VerifyController)

	logout := new(auth.LogoutController)

	two_fa := new(auth.TwoFaController)
	refresh := new(auth.RefreshController)

	routeGroup.POST("/register", register.Register)
	routeGroup.POST("/login", login.Login)

	routeGroup.POST("/password-recovery", password_recovery.PasswordRecovery)
	routeGroup.POST("/password-change", password_change.PasswordChange)
	routeGroup.POST("/reset-password", password_recovery.PasswordReset)
	routeGroup.POST("/verify", verify.VerifyUser)
	// routeGroup.POST("/resend-verification-email", verify.ResendVerificationEmail)

	routeGroup.POST("/logout", logout.Logout)

	routeGroup.GET("/twofa/enable/request", two_fa.TwoFAEnableRequest)
	routeGroup.POST("/twofa/enable/confirm", two_fa.TwoFAEnableConfirm)
	routeGroup.POST("/twofa/login/confirm", two_fa.TwoFALoginConfirm)
	routeGroup.GET("/refresh", refresh.Status)
}

func InitFavoritesRoute(routeGroup *gin.RouterGroup) {
	addFavorite := new(favorites.AddFavoriteController)
	retrieveFavorite := new(favorites.RetrieveFavoriteController)
	removeFavorite := new(favorites.RemoveFavoriteController)

	routeGroup.POST("/add", addFavorite.AddFavorite)
	routeGroup.GET("/get", retrieveFavorite.RetrieveFavorites)
	routeGroup.DELETE("/remove", removeFavorite.RemoveFavorite)
}

func InitTransactionRoutes(routeGroup *gin.RouterGroup) {
	verify := new(transaction.TransactionVerifyController)
	refresh_controller := new(transaction.RefreshController)

	routeGroup.GET("/verify", verify.Status)
	routeGroup.GET("/refresh", refresh_controller.Status)
}

func InitToolsRoutes(routeGroup *gin.Engine) {
	health := new(tools.HealthController)
	authCheck := new(tools.AuthCheckController)

	routeGroup.GET("/health", health.Status)
	routeGroup.GET("/utils/auth_check", authCheck.AuthCheck)
}

func RegisterRoutes(router *gin.Engine) *gin.Engine {
	InitToolsRoutes(router)

	v1 := router.Group("v1")
	{
		InitAuthRoutes(v1.Group("auth"))
		InitFavoritesRoute(v1.Group("favorites"))
		InitTransactionRoutes(v1.Group("transaction"))
	}

	return router
}
