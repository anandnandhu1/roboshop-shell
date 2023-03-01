source common.sh
component=dispatch
schema_load=false

if [ -z "${roboshop_rabbitmq_password}" ]; then
  echo "variable roboshop_rabbitmq_password is missing"
  exit
fi

print_head "install golang"
yum install golang -y &>>${LOG}
status_check

APP_PREREQ

print_head "change directory and dispatch"
cd /app &>>${LOG}
go mod init dispatch &>>${LOG}
status_check

print_head "get dependancies"
go get &>>${LOG}
status_check

print_head "build depandancies"
go build &>>${LOG}
status_check

print_head "update password in service file"
sed -i -e "s/roboshop_rabbitmq_password/${roboshop_rabbitmq_password}/" ${script_location}/files/${component}.service &>>${LOG}
status_check

SYSTEMD_SETUP