package core

import (
	"main/telemetry"
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/go-playground/validator/v10"
)

var Validator *validator.Validate = validator.New()

func HandleValidationError(c *gin.Context, err error) {
	validationErrors, ok := err.(validator.ValidationErrors)
	if !ok {
		telemetry.Logger(c).Sugar().Errorw("Failed to validate user",
			"error", err,
		)
		c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"msg": "Internal Server Error", "context": telemetry.TraceIDFromContext(c)})
		return
	}

	// Build a map to store the validation errors
	errors := make(map[string]string)

	// Loop through each validation error and add it to the errors map
	for _, fieldError := range validationErrors {
		errors[fieldError.Field()] = fieldError.Tag()
	}

	telemetry.Logger(c).Sugar().Errorw("Failed to validate user",
		"errors", errors,
	)

	c.AbortWithStatusJSON(http.StatusBadRequest, gin.H{"msg": "Validation error", "errors": errors, "context": telemetry.TraceIDFromContext(c)})
	return
}
