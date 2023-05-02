ssh ubuntu@rosemary "rm /home/ubuntu/aaryapay/*.sh && rm -rf /home/ubuntu/aaryapay/etc && mkdir -p /home/ubuntu/aaryapay/etc/proxy"

scp *.sh ubuntu@rosemary:/home/ubuntu/aaryapay

ssh ubuntu@rosemary chmod +x /home/ubuntu/aaryapay/*.sh

scp ../api/etc/staging.yaml ubuntu@rosemary:/home/ubuntu/aaryapay/etc/
scp ./proxy/*.yml ubuntu@rosemary:/home/ubuntu/aaryapay/etc/proxy
