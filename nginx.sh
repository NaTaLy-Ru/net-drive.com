# ===================== Run ==================== #
# !/bin/bash                                     #
# sudo bash ./nginx.sh                           #
# sudo -i                                        #
# ================ Permissions ================= #
# chmod +x nginx.sh                              #
# =================== Errors =================== #

set -eux

# ================== Cleanup =================== #

apt purge nginx -y
mkdir -p /var/www/mysite

# ================== Updating ================== #

# echo "<<< Starting Update >>>"
echo -e "\e[36m<<< Starting Update >>>\e[0m"
apt update -y
# echo "<<< The Update has been completed >>>"
echo -e "\e[32m<<< The Update has been completed >>>\e[0m"

# ============== Nginx Installing ============== #

# echo "<<< Starting Installation & Configuration >>>"
echo -e "\e[36m<<< Ngnix Installation & Configuration >>>\e[0m"
apt install nginx -y
systemctl enable --now nginx
sudo sed -i 's|root /var/www/html;|root /var/www/mysite;|' /etc/nginx/sites-available/default

# ========= Creating an HTML web page ========== #

cat > /var/www/mysite/index.html <<EOF
<!DOCTYPE html>
<html>
<head>
    <style>
        body {
            text-align: center;
            background: #111;
            color: white;
            font-family: Arial, sans-serif;
        }

        h1 {
            font-size: 50px;
            font-weight: bold;

            background: linear-gradient(
                90deg,
                orange, yellow, red, cyan,  blue
            );

            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }
    </style>
</head>
<body>
    <h1>WellCome to Nginx :)</h1>
</body>
</html>
EOF

# ========= Creating an Error Page 404 ========= #

cat > /var/www/mysite/404.html <<EOF
<!DOCTYPE html>
<html>
<head>
  <title>404</title>
  <style>
        body {
            text-align: center;
        }
    </style>
</head>
<body>
    <h1><<< Error 404 >>></h1>
    <h2>Page Not Found</h2>
</body>
</html>
EOF

sed -i '/server_name _;/a \    error_page 404 /404.html;' /etc/nginx/sites-available/default

# ======= Change Port Nginx (80 >> 8080) ======= #

ufw allow 8080/tcp
sed -i 's/listen 80 default_server;/listen 8080 default_server;/' /etc/nginx/sites-available/default
sed -i 's/listen \[::\]:80 default_server;/listen [::]:8080 default_server;/' /etc/nginx/sites-available/default

# ========= Nginx Configuration check ========== #

nginx -t

# ================ Nginx Reboot ================ #

systemctl restart nginx
echo -e "\e[32m<<< Nginx has been installed successfully! >>>\e[0m"

# ================== Testing =================== #

echo -e "\e[36m<<< Start Testing>>>\e[0m"
apt install curl
curl -I http://localhost:8080
curl -I http://localhost:8080/test

echo -e "\e[32m<<< Testing Successed >>>\e[0m"
echo -e "\e[95m<<< Now You can open http://localhost:8080 >>>\e[0m"

# ================== The End =================== #

