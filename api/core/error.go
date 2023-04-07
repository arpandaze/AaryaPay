package core

import (
	"fmt"
)

type AppError interface {
	Error() string
	StatusCode() int
	Message() string
}

type GeneralError struct {
	err        *error
	statusCode int
	message    string
}

func (r *GeneralError) Error() string {
	return fmt.Sprintf("status %d: err %v", r.statusCode, r.err)
}

func (r *GeneralError) StatusCode() int {
	return r.statusCode
}

func (r *GeneralError) Message() string {
	return r.message
}
