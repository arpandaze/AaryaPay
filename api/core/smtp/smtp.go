package smtp

import (
	"bytes"
	"fmt"
	"html/template"
	conf "main/core"
	"net/smtp"
)

type Request struct {
	from    string
	to      []string
	subject string
	body    string
}

func (r *Request) ParseTemplate(templateFileName string, data interface{}) error {

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

func SendEmail(emailRequest *Request) (bool, error) {

	if conf.Configs.EMAILS_ENABLED() {
		//TODO: configure TLS

		var auth = smtp.PlainAuth("", conf.Configs.SMTP_USER, conf.Configs.SMTP_PASSWORD, conf.Configs.SMTP_HOST)

		mime := "MIME-version: 1.0;\nContent-Type: text/html; charset=\"UTF-8\";\n\n"
		msg := []byte(emailRequest.subject + mime + "\n" + emailRequest.body)
		if err := smtp.SendMail(fmt.Sprintf("%s:%d", conf.Configs.SMTP_HOST, conf.Configs.SMTP_PORT), auth, "noreply@aaryapay.com", emailRequest.to, msg); err != nil {
			return false, fmt.Errorf("email could not be sent")
		}

		return true, fmt.Errorf("email is sent successfully")

	} else {
		return false, fmt.Errorf("emails are currently disabled")
	}
}

func SendVerificationEmail(firstname string, email string) {
	re := &Request{}
	re.from = "noreply@aaryapay.com"
	re.to = []string{email}
	re.subject = fmt.Sprintf("Subject: %s - Verification Email\n", conf.Configs.PROJECT_NAME)

	var tokenLink = "generatelinkherewithtoken"

	templateData := struct {
		Frontbase string
		Name      string
		Link      string
	}{
		Frontbase: conf.Configs.FRONTEND_HOST,
		Name:      firstname,
		Link:      tokenLink,
	}

	if err := re.ParseTemplate(fmt.Sprintf("%s/verify-account.html", conf.Configs.EMAIL_TEMPLATES_DIR), templateData); err == nil {
		SendEmail(re)
	}

}

func SendResetPasswordEmail(firstname string, email string) {
	re := &Request{}
	re.from = "noreply@aaryapay.com"
	re.to = []string{email}
	re.subject = fmt.Sprintf("Subject: %s - Password Recovery\n", conf.Configs.PROJECT_NAME)

	var tokenLink = "generatelinkherewithtoken"

	templateData := struct {
		Frontbase string
		Name      string
		Link      string
	}{
		Frontbase: conf.Configs.FRONTEND_HOST,
		Name:      firstname,
		Link:      tokenLink,
	}

	if err := re.ParseTemplate(fmt.Sprintf("%s/reset-password.html", conf.Configs.EMAIL_TEMPLATES_DIR), templateData); err == nil {
		SendEmail(re)
	}
}
