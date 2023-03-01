source common.sh

if [ -z "${roboshop_rabbitmq_passwoed}" ]; then
  echo "variable roboshop_rabbitmq_password is missing"
  exit
fi

print_head "configuring erlang yum repo"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | sudo bash &>>${LOG}
status_check

print_head "configuring rabbitmq yum repos"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash &>>${LOG}
status_check

print_head "install erlang and rabbitmq"
yum install erlang rabbitmq-server -y &>>${LOG}
status_check

print_head "enable rabbitmq server"
systemctl enable rabbitmq-server &>>${LOG}
status_check

print_head "start rabbitmq server"
systemctl start rabbitmq-server &>>${LOG}
status_check

print_head "add application user"
rabbitmqctl add_user roboshop ${roboshop_rabbitmq_passwoed} &>>${LOG}
status_check

print_head "add tags to application user"
rabbitmqctl set_user_tags roboshop administrator &>>${LOG}
status_check

print_head "add permission to application user"
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>${LOG}
status_check

