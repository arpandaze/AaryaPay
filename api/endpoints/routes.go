package endpoints

import (
	auth "main/endpoints/auth"
	favorites "main/endpoints/favorites"
	keys "main/endpoints/keys"
	"main/endpoints/profile"
	tools "main/endpoints/tools"
	transaction "main/endpoints/transaction"

	"github.com/gin-gonic/gin"
)

func InitAuthRoutes(routeGroup *gin.RouterGroup) {
	register := new(auth.RegisterController)
	login := new(auth.LoginController)

	passwordRecovery := new(auth.PasswordRecoveryController)
	passwordChange := new(auth.PasswordChangeController)
	verify := new(auth.VerifyController)

	logout := new(auth.LogoutController)

	twoFA := new(auth.TwoFaController)
	refresh := new(auth.RefreshController)
	resend_verification := new(auth.ResendVerificationController)

	routeGroup.POST("/register", register.Register)
	routeGroup.POST("/login", login.Login)
	routeGroup.POST("/resend-verification", resend_verification.ResendVerification)

	routeGroup.POST("/password-recovery", passwordRecovery.PasswordRecovery)
	routeGroup.POST("/password-change", passwordChange.PasswordChange)
	routeGroup.POST("/reset-password", passwordRecovery.PasswordReset)
	routeGroup.POST("/verify", verify.VerifyUser)
	// routeGroup.POST("/resend-verification-email", verify.ResendVerificationEmail)

	routeGroup.POST("/logout", logout.Logout)

	routeGroup.GET("/twofa/enable/request", twoFA.TwoFAEnableRequest)
	routeGroup.POST("/twofa/enable/confirm", twoFA.TwoFAEnableConfirm)
	routeGroup.POST("/twofa/login/confirm", twoFA.TwoFALoginConfirm)
	routeGroup.GET("/refresh", refresh.Status)
}

func InitFavoritesRoute(routeGroup *gin.RouterGroup) {
	addFavorite := new(favorites.AddFavoriteController)
	retrieveFavorite := new(favorites.RetrieveFavoriteController)
	removeFavorite := new(favorites.RemoveFavoriteController)

	routeGroup.POST("", addFavorite.AddFavorite)
	routeGroup.GET("", retrieveFavorite.RetrieveFavorites)
	routeGroup.DELETE("", removeFavorite.RemoveFavorite)
}

func InitProfileRoutes(routeGroup *gin.RouterGroup) {
	retrieveProfileController := new(profile.GetProfileController)
	routeGroup.GET("", retrieveProfileController.GetProfile)
}

func InitTransactionRoutes(routeGroup *gin.RouterGroup) {
	retrieveController := new(transaction.TransactionRetrieve)
	submitController := new(transaction.SubmitController)

	routeGroup.GET("", retrieveController.Retrieve)
	routeGroup.POST("", submitController.Submit)
}

func InitKeysRoutes(routeGroup *gin.RouterGroup) {
	serverKeysController := new(keys.ServerKeysController)

	routeGroup.GET("/server_keys", serverKeysController.ServerPubKey)
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
		InitProfileRoutes(v1.Group("profile"))
		InitFavoritesRoute(v1.Group("favorites"))
		InitTransactionRoutes(v1.Group("transaction"))
		InitKeysRoutes(v1.Group("keys"))
	}

	return router
}
