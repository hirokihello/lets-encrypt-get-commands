.PHONY: cert-setup-4mac
cert-setup-4mac:
	brew install certbot
	mkdir your/cert/check/dir
	chmod 777 your/cert/check/dir
	sudo certbot certonly --webroot --webroot-path your/cert/check/dir -d example.com
	echo "0 0 1 * * root python -c 'import random; import time; time.sleep(random.random() * 3600)' && certbot renew -q"" | sudo t e -a /etc/crontab > /dev/null
