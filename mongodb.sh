source common.sh

print_head "copy mongodb repo file"
cp ${script_location}/files/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>${LOG}
status_check

print_head "install mongodb"
yum install mongodb-org -y &>>${LOG}
status_check

print_head "update mongodb listen address"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>>${LOG}
status_check

print_head "enable mongodb"
systemctl enable mongod &>>${LOG}
status_check

print_head "restart mongodb"
systemctl restart mongod &>>${LOG}
status_check