script_location=$(pwd)
echo -e "\e[35m install nginx\e[0m"
yum install nginx -y

echo -e "\e[35 remove nginx old content\e[0m"
rm -rf /usr/share/nginx/html/*

echo -e "/e[35 download frontend content\e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip

cd /usr/share/nginx/html
echo -e "\e[35m extract frontend content\e[om"
unzip /tmp/frontend.zip

echo -e "\e[35 copy roboshop nginx config  file\e[0m"
cp ${script_location}/files/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf

echo -e "\e[35 enable nginx\e[om"
systemctl enable nginx

echo -e "\e[35 restart nginx file"
systemctl restart nginx