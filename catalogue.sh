script_location=$(pwd)
LOG=/tmp/roboshop.log

echo -e "\e[35m configure node js repos\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${LOG}
if [ $? -eq 0 ]; then
  echo SUCESS
else
  echo FAILURE
fi

echo -e "\e[35m install nodejs\e[0m"
yum install nodejs -y &>>${LOG}
if [ $? -eq 0 ]; then
  echo SUCESS
else
  echo FAILURE
fi

echo -e "\e[35m add application user\e[0m"
useradd roboshop &>>${LOG}
if [ $? -eq 0 ]; then
  echo SUCESS
else
  echo FAILURE
fi

mkdir -p /app &>>${LOG}

echo -e "\e[35m downloading app content\e[0m"
curl -L -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>${LOG}
if [ $? -eq 0 ]; then
  echo SUCESS
else
  echo FAILURE
fi

echo -e "\e[35m cleanup old content\e[0m"
rm -rf /app/* &>>${LOG}
if [ $? -eq 0 ]; then
  echo SUCESS
else
  echo FAILURE
fi

echo -e "\e[35m extract old content\e[0m"
cd /app &>>${LOG}
unzip /tmp/catalogue.zip &>>${LOG}
if [ $? -eq 0 ]; then
  echo SUCESS
else
  echo FAILURE
fi

echo -e "\e[35m install nodejs dependancies\e[0m"
cd /app &>>${LOG}
npm install &>>${LOG}
if [ $? -eq 0 ]; then
  echo SUCESS
else
  echo FAILURE
fi

echo -e "\e[35m configure catalogue service file\e[0m"
cp ${script_location}/files/catalogue.service /etc/systemd/system/catalogue.service &>>${LOG}
if [ $? -eq 0 ]; then
  echo SUCESS
else
  echo FAILURE
fi

echo -e "\e[35m reload systemd\e[0m"
systemctl daemon-reload &>>${LOG}
if [ $? -eq 0 ]; then
  echo SUCESS
else
  echo FAILURE
fi

echo -e "\e[35m enable catalogue server\e[0m"
systemctl enable catalogue &>>${LOG}
if [ $? -eq 0 ]; then
  echo SUCESS
else
  echo FAILURE
fi

echo -e "\e[35m start catalogue server\e[0m"
systemctl start catalogue &>>${LOG}
if [ $? -eq 0 ]; then
  echo SUCESS
else
  echo FAILURE
fi

echo -e "\e[35m configuring mongo repo\e[0m"
cp ${script_location}/files/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>${LOG}
if [ $? -eq 0 ]; then
  echo SUCESS
else
  echo FAILURE
fi

echo -e "\e[35m install mongo client\e[0m"
yum install mongodb-org-shell -y &>>${LOG}
if [ $? -eq 0 ]; then
  echo SUCESS
else
  echo FAILURE
fi

echo -e "\e[35m load schema\e[0m"
mongo --host mongodb-dev.anandnandhu.online </app/schema/catalogue.js &>>${LOG}
if [ $? -eq 0 ]; then
  echo SUCESS
else
  echo FAILURE
fi