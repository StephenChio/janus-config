#! /bin/bash
ip=$1
rabbitmqHost=$2
if [ ! -f "docker-compose.yaml" ]; then
        touch "docker-compose.yaml"
else
        rm -rf docker-compose.yaml
fi                       
echo "version: '2.1'">>"docker-compose.yaml"
echo "services:">>"docker-compose.yaml"
echo "  janus-gateway:">>"docker-compose.yaml"
echo "    container_name: janus">>"docker-compose.yaml"
echo "    image: 'canyan/janus-gateway:0.10.7'">>"docker-compose.yaml"
echo "    command: ['/usr/local/bin/janus','-F','/usr/local/etc/janus']">>"docker-compose.yaml"
echo "    volumes:  ">>"docker-compose.yaml"
echo "      - '/opt/janus/etc/janus:/usr/local/etc/janus'">>"docker-compose.yaml"
echo "    restart: always">>"docker-compose.yaml"
echo "    network_mode: 'host'">>"docker-compose.yaml"    
yum -y install docker
systemctl start docker
yum install -y git 
yum install -y python3
python3 -m pip install --upgrade pip
pip3 install setuptools_rust
pip3 install docker-compose
rm -rf /opt/janus
mkdir /opt/janus
mkdir /opt/janus/etc
git clone http://gitlab.gms.com/Stephen.qiu/janus-config.git /opt/janus/etc/janus
sed -i "s/to-janus/to-janus$ip/g" /opt/janus/etc/janus/janus.transport.rabbitmq.jcfg
sed -i "s/rabbitmqHost/$rabbitmqHost/g" /opt/janus/etc/janus/janus.transport.rabbitmq.jcfg
docker stop janus
docker-compose up -d
