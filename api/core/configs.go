package core

import (
	"fmt"
	"log"
	"os"

	"gopkg.in/yaml.v3"
)

type Settings struct {
	API_STR                      string `yaml:"API_STR"`
	SECRET_KEY                   string `yaml:"SECRET_KEY"`
	SESSION_EXPIRE_TIME          int    `yaml:"SESSION_EXPIRE_TIME"`
	SESSION_EXPIRE_TIME_EXTENDED int    `yaml:"SESSION_EXPIRE_TIME_EXTENDED"`
	TWO_FA_TIMEOUT               int    `yaml:"TWO_FA_TIMEOUT"`
	PASSWORD_LESS_CREATE_TIMEOUT int    `yaml:"PASSWORD_LESS_CREATE_TIMEOUT"`
	SERVER_NAME                  string `yaml:"SERVER_NAME"`

	PROTOCAL string `yaml:"PROTOCAL"`
	MODE     string `yaml:"MODE"`

	BACKEND_HOST string `yaml:"BACKEND_HOST"`
	BACKEND_PORT int    `yaml:"BACKEND_PORT"`

	STATIC_HOST string `yaml:"STATIC_HOST"`
	STATIC_PORT int    `yaml:"STATIC_PORT"`

	FRONTEND_HOST string `yaml:"FRONTEND_HOST"`
	FRONTEND_PORT int    `yaml:"FRONTEND_PORT"`

	UPLOAD_DIR_ROOT string `yaml:"UPLOAD_DIR_ROOT"`

	BACKEND_CORS_ORIGIN []string `yaml:"BACKEND_CORS_ORIGIN"`
	ALLOWED_EMAIL_HOST  []string `yaml:"ALLOWED_EMAIL_HOST"`
	PROJECT_NAME        string   `yaml:"PROJECT_NAME"`

	POSTGRES_SERVER   string `yaml:"POSTGRES_SERVER"`
	POSTGRES_PORT     int    `yaml:"POSTGRES_PORT"`
	POSTGRES_USER     string `yaml:"POSTGRES_USER"`
	POSTGRES_PASSWORD string `yaml:"POSTGRES_PASSWORD"`
	POSTGRES_DB       string `yaml:"POSTGRES_DB"`

	REDIS_SERVER   string `yaml:"REDIS_SERVER"`
	REDIS_PORT     int    `yaml:"REDIS_PORT"`
	REDIS_USER     string `yaml:"REDIS_USER"`
	REDIS_PASSWORD string `yaml:"REDIS_PASSWORD"`

	SMTP_TLS      bool   `yaml:"SMTP_TLS"`
	SMTP_PORT     int    `yaml:"SMTP_PORT"`
	SMTP_HOST     string `yaml:"SMTP_HOST"`
	SMTP_USER     string `yaml:"SMTP_USER"`
	SMTP_PASSWORD string `yaml:"SMTP_PASSWORD"`

	EMAILS_FROM_EMAIL string `yaml:"EMAILS_FROM_EMAIL"`

	EMAIL_RESET_TOKEN_EXPIRE_HOURS int    `yaml:"EMAIL_RESET_TOKEN_EXPIRE_HOURS"`
	EMAIL_VERIFY_EXPIRE_HOURS      int    `yaml:"EMAIL_VERIFY_EXPIRE_HOURS"`
	EMAIL_TEMPLATES_DIR            string `yaml:"EMAIL_TEMPLATES_DIR"`

	FIRST_SUPERUSER          string `yaml:"FIRST_SUPERUSER"`
	FIRST_SUPERUSER_PASSWORD string `yaml:"FIRST_SUPERUSER_PASSWORD"`
	USERS_OPEN_REGISTRATION  bool   `yaml:"USERS_OPEN_REGISTRATION"`

	ARGON_MEMORY      uint32 `yaml:"ARGON_MEMORY"`
	ARGON_TIME        uint32 `yaml:"ARGON_TIME"`
	ARGON_ITERATIONS  uint32 `yaml:"ARGON_ITERATIONS"`
	ARGON_PARALLELISM uint8  `yaml:"ARGON_PARALLELISM"`
	ARGON_SALT_LENGTH uint32 `yaml:"ARGON_SALT_LENGTH"`
	ARGON_KEY_LENGTH  uint32 `yaml:"ARGON_KEY_LENGTH"`
}

func (r Settings) BACKEND_URL_BASE() string {
	if (r.BACKEND_PORT) == 80 {
		return fmt.Sprintf("%s://%s", r.PROTOCAL, r.BACKEND_HOST)
	} else {
		return fmt.Sprintf("%s://%s:%d", r.PROTOCAL, r.BACKEND_HOST, r.BACKEND_PORT)
	}
}

func (r Settings) STATIC_URL_BASE() string {
	if (r.STATIC_PORT) == 80 {
		return fmt.Sprintf("%s://%s", r.PROTOCAL, r.STATIC_HOST)
	} else {
		return fmt.Sprintf("%s://%s:%d", r.PROTOCAL, r.STATIC_HOST, r.STATIC_PORT)
	}
}

func (r Settings) FRONTEND_URL_BASE() string {
	if (r.FRONTEND_PORT) == 80 {
		return fmt.Sprintf("%s://%s", r.PROTOCAL, r.FRONTEND_HOST)
	} else {
		return fmt.Sprintf("%s://%s:%d", r.PROTOCAL, r.FRONTEND_HOST, r.FRONTEND_PORT)
	}
}
func (r Settings) DEV_MODE() bool {
	if r.MODE == "dev" {
		return true
	} else {
		return false
	}
}

func (r Settings) POSTGRES_DATABASE_URI(ssl bool) string {
	if ssl {
		return fmt.Sprintf("postgres://%s:%s@%s:%d/%s", r.POSTGRES_USER, r.POSTGRES_PASSWORD, r.POSTGRES_SERVER, r.POSTGRES_PORT, r.POSTGRES_DB)
	} else {
		return fmt.Sprintf("postgres://%s:%s@%s:%d/%s?sslmode=disable", r.POSTGRES_USER, r.POSTGRES_PASSWORD, r.POSTGRES_SERVER, r.POSTGRES_PORT, r.POSTGRES_DB)
	}
}

func (r Settings) EMAILS_FROM_NAME() string {
	return r.PROJECT_NAME
}

func (r Settings) EMAILS_ENABLED() bool {
	return len(r.SMTP_HOST) != 0 && r.SMTP_PORT != 0 && len(r.EMAILS_FROM_EMAIL) != 0
}

var Configs Settings

func LoadConfig() {
	f, err := os.ReadFile("./etc/dev.yaml")
	if err != nil {
		log.Fatal(err)
	}

	if err := yaml.Unmarshal(f, &Configs); err != nil {
		log.Fatal(err)
	}
}
