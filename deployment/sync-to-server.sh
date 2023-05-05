if [ -z "$SSH_DEPLOY_HOST" ]; then
    SSH_DEPLOY_HOST="155.248.247.182"
fi

ssh -o StrictHostKeyChecking=no ubuntu@$SSH_DEPLOY_HOST "
  rm /home/ubuntu/aaryapay/*.sh
  rm -rf /home/ubuntu/aaryapay/etc
  rm -rf /home/ubuntu/aaryapay/templates/email-templates
  mkdir -p /home/ubuntu/aaryapay/etc/proxy
  mkdir -p /home/ubuntu/aaryapay/etc/telemetry
  mkdir -p /home/ubuntu/aaryapay/templates/email-templates
"

scp -o StrictHostKeyChecking=no *.sh ubuntu@$SSH_DEPLOY_HOST:/home/ubuntu/aaryapay

ssh -o StrictHostKeyChecking=no ubuntu@$SSH_DEPLOY_HOST chmod +x /home/ubuntu/aaryapay/*.sh

scp -o StrictHostKeyChecking=no ../api/etc/staging.yaml ubuntu@$SSH_DEPLOY_HOST:/home/ubuntu/aaryapay/etc/
scp -o StrictHostKeyChecking=no ../api/templates/email-templates/*.html ubuntu@$SSH_DEPLOY_HOST:/home/ubuntu/aaryapay/templates/email-templates
scp -o StrictHostKeyChecking=no ./proxy/*.yml ubuntu@$SSH_DEPLOY_HOST:/home/ubuntu/aaryapay/etc/proxy
scp -o StrictHostKeyChecking=no ./telemetry/*.yml ubuntu@$SSH_DEPLOY_HOST:/home/ubuntu/aaryapay/etc/telemetry
