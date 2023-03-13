package smtp

import (
	"bytes"
	"fmt"
	"html/template"
	"main/core"
	"net/smtp"
)

type Request struct {
	from    string
	to      []string
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

	if core.Configs.EMAILS_ENABLED() {
		//TODO: configure TLS

		var auth = smtp.PlainAuth("", core.Configs.SMTP_USER, core.Configs.SMTP_PASSWORD, core.Configs.SMTP_HOST)

		mime := "MIME-version: 1.0;\nContent-Type: text/html; charset=\"UTF-8\";\n\n"
		msg := []byte(emailRequest.subject + mime + "\n" + emailRequest.body)
		if err := smtp.SendMail(fmt.Sprintf("%s:%d", core.Configs.SMTP_HOST, core.Configs.SMTP_PORT), auth, "noreply@aaryapay.com", emailRequest.to, msg); err != nil {
			return false, fmt.Errorf("email could not be sent")
		}

		return true, nil

	} else {
		return false, fmt.Errorf("emails are currently disabled")
	}
}

func SendVerificationEmail(user *core.CommonUser) (bool, error) {
	re := &Request{}
	re.from = "noreply@aaryapay.com"
	re.to = []string{user.Email}
	re.subject = fmt.Sprintf("Subject: %s - Verification Email\n", core.Configs.PROJECT_NAME)

	var tokenLink = "generatelinkherewithtoken"

	templateData := struct {
		Frontbase string
		Name      string
		Link      string
	}{
		Frontbase: core.Configs.FRONTEND_HOST,
		Name:      user.FirstName,
		Link:      tokenLink,
	}

	if err := re.ParseTemplate(fmt.Sprintf("%s/verify-account.html", core.Configs.EMAIL_TEMPLATES_DIR), templateData); err == nil {
		res, resErr := SendEmail(re)
		if res {
			return true, resErr
		}
	}
	return false, fmt.Errorf("email could not be sent at this moment")
}

func SendResetPasswordEmail(user *core.CommonUser) (bool, error) {
	re := &Request{}
	re.from = "noreply@aaryapay.com"
	re.to = []string{user.Email}
	re.subject = fmt.Sprintf("Subject: %s - Password Recovery\n", core.Configs.PROJECT_NAME)

	var tokenLink = "generatelinkherewithtoken"

	templateData := struct {
		Frontbase string
		Name      string
		Link      string
	}{
		Frontbase: core.Configs.FRONTEND_HOST,
		Name:      user.FirstName,
		Link:      tokenLink,
	}

	if err := re.ParseTemplate(fmt.Sprintf("%s/reset-password.html", core.Configs.EMAIL_TEMPLATES_DIR), templateData); err == nil {
		res, resErr := SendEmail(re)
		if res {
			return true, resErr
		}
	}

	return false, fmt.Errorf("email could not be sent at this moment")
}
