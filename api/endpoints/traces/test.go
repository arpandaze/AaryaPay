package traces

import (
	"net/http"

	"github.com/gin-gonic/gin"
)

type TestController struct{}

func (TestController) Test(c *gin.Context) {


	// var favInput struct {
	// 	Level string `json:"ts"`
	// }
	// if err := c.Bind(&favInput); err != nil {
	// 	msg := "Invalid Request Payload"
	// 	c.AbortWithStatusJSON(http.StatusBadRequest, gin.H{"msg": msg})
	// 	return
	// }
	// fmt.Println("")
	// fmt.Println("")
	// fmt.Println("")

	// fmt.Println(favInput.Level)

	// fmt.Println("")
	// fmt.Println("")

	c.JSON(http.StatusOK, gin.H{"msg":""})
}
