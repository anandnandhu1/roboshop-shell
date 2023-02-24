script_location=$(pwd)

cp ${script_locaion}/files/mongodb.repo /etc/yum.repos.d/mongodb.repo

yum install mongodb-org -y

sed -e -i 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf

systemctl enable mongod
systemctl start mongod
