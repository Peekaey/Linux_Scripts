sudo apt-get update && sudo apt-get upgrade

echo "Installing Certbot"
sleep 3s
sudo snap install --classic certbot
sudo certbot certonly --standalone

echo "Preparing to install Grafana"
sleep 3s
sudo apt-get install -y apt-transport-https
sudo apt-get install -y software-properties-common wget
wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add -
echo "deb https://packages.grafana.com/oss/deb stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list
sudo apt-get update
sudo apt-get install grafana
echo"Preparing to configure/move certificates for SSL"
sleep 3s

read -p "Please Enter Your Domain Name (The one you entered when configurating the certificate with the certbot" domain
echo "You entered $domain"

echo "Moving certificate keys into grafana"
cp /etc/letsencrypt/live/$domain/*.pem /etc/grafana/
chown :grafana /etc/grafana/fullchain.pem
chown :grafana /etc/grafana/privkey.pem
chmod 640 /etc/grafana/fullchain.pem
chmod 640 /etc/grafana/privkey.pem

echo "auto configuration for grafana is completed, all that is left to do is to edit the grafana config file found at /etc/grafana/grafana.ini"
sleep 2s
echo "please change the line ;protocol = http To protocol = https"
echo "please change the line 
;cert_file =
;cert_key =
to
cert_file = /etc/grafana/fullchain.pem
cert_key = /etc/grafana/privkey.pem
"

echo "Setup finished"
sudo systemctl restart grafana
