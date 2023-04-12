package core

import (
	"bytes"
	"fmt"
	"html/template"
	. "main/telemetry"
	"net/smtp"

	"github.com/gin-gonic/gin"
	"github.com/jhillyerd/enmime"
)

type Request struct {
	to      string
	subject string
	body    string
}

type User struct {
	FirstName  string
	MiddleName string
	LastName   string
	DOB        string
	Email      string
	Password   string
}

func (r *Request) ParseTemplate(c *gin.Context, templateFileName string, data interface{}) error {
	_, span := Tracer.Start(c.Request.Context(), "ParseTemplate()")
	defer span.End()

	t, err := template.ParseFiles(templateFileName)

	if err != nil {
		return err
	}

	buf := new(bytes.Buffer)
	if err = t.Execute(buf, data); err != nil {
		return err
	}
	r.body = buf.String()
	return nil
}

func SendEmail(c *gin.Context, emailRequest *Request) (bool, error) {
	_, span := Tracer.Start(c.Request.Context(), "SendEmail()")
	defer span.End()

	if Configs.EMAILS_ENABLED() {
		//TODO: configure TLS

		from := Configs.EMAILS_FROM_EMAIL

		var auth = smtp.PlainAuth(from, Configs.SMTP_USER, Configs.SMTP_PASSWORD, Configs.SMTP_HOST)

		var client = enmime.NewSMTP(fmt.Sprint(Configs.SMTP_HOST, ":", Configs.SMTP_PORT), auth)

		var email = enmime.
			Builder().
			From(Configs.PROJECT_NAME, Configs.EMAILS_FROM_EMAIL).
			To("", emailRequest.to).
			Subject(emailRequest.subject).
			HTML([]byte(emailRequest.body))

		err := email.Send(client)

		if err != nil {
			Logger(c).Sugar().Errorw("Failed to send email!",
				"error", err,
			)
			return false, err
		}

		return true, nil

	} else {
		Logger(c).Sugar().Errorw("Email is disabled!")
		return false, nil
	}
}

func SendVerificationEmail(c *gin.Context, user *CommonUser) (bool, error) {
	_, span := Tracer.Start(c.Request.Context(), "SendVerificationEmail()")
	defer span.End()

	re := &Request{}
	re.to = user.Email
	re.subject = fmt.Sprintf("%s - Verification Email\n", Configs.PROJECT_NAME)

	token := GenerateVerificationToken(c, user.Id)

	templateData := struct {
		Frontbase string
		Name      string
		Link      string
	}{
		Frontbase: Configs.FRONTEND_HOST,
		Name:      user.FirstName,
		Link:      token,
	}

	err := re.ParseTemplate(c, fmt.Sprintf("%s/verify-account.html", Configs.TEMPLATE_DIR()), templateData)

	if err != nil {
		Logger(c).Sugar().Errorw("Failed to parse email template!",
			"error", err,
		)
		return false, err
	}

	res, err := SendEmail(c, re)

	if err != nil {
		return false, err
	} else {
		return res, nil
	}
}

func SendResetPasswordEmail(c *gin.Context, user *CommonUser) (bool, error) {
	re := &Request{}
	re.to = user.Email
	re.subject = fmt.Sprintf("%s - Password Recovery\n", Configs.PROJECT_NAME)

	token := GenerateResetToken(c, user.Id)

	templateData := struct {
		Frontbase string
		Name      string
		Link      string
	}{
		Frontbase: Configs.FRONTEND_HOST,
		Name:      user.FirstName,
		Link:      token,
	}

	if err := re.ParseTemplate(c, fmt.Sprintf("%s/reset-password.html", Configs.EMAIL_TEMPLATES_DIR), templateData); err == nil {
		res, resErr := SendEmail(c, re)
		if res {
			return true, resErr
		}
	}

	return false, fmt.Errorf("email could not be sent at this moment")
}
