source common.sh

print_head "configure node js repos"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${LOG}
status_check

print_head "install nodejs"
yum install nodejs -y &>>${LOG}
status_check

print_head "add application user"
useradd roboshop &>>${LOG}
status_check

mkdir -p /app &>>${LOG}

print_head "downloading app content"
curl -L -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>${LOG}
status_check

print_head "cleanup old content"
rm -rf /app/* &>>${LOG}
status_check

print_head "extract old content"
cd /app &>>${LOG}
unzip /tmp/catalogue.zip &>>${LOG}
status_check

print_head "install nodejs dependancies"
cd /app &>>${LOG}
npm install &>>${LOG}
status_check

print_head "configure catalogue service file"
cp ${script_location}/files/catalogue.service /etc/systemd/system/catalogue.service &>>${LOG}
status_check

print_head "reload systemd"
systemctl daemon-reload &>>${LOG}
status_check

print_head "enable catalogue server"
systemctl enable catalogue &>>${LOG}
status_check

print_head "start catalogue server"
systemctl start catalogue &>>${LOG}
status_check

print_head "configuring mongo repo"
cp ${script_location}/files/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>${LOG}
status_check

print_head "install mongo client"
yum install mongodb-org-shell -y &>>${LOG}
status_check

print_head "load schema"
mongo --host mongodb-dev.anandnandhu.online </app/schema/catalogue.js &>>${LOG}
status_check