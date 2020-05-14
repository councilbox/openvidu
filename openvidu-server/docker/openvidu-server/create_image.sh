cp ../../target/openvidu-server-*.jar ./openvidu-server.jar
cp ../utils/discover_my_public_ip.sh ./discover_my_public_ip.sh

docker build -t councilbox/server-java .

rm ./openvidu-server.jar
rm ./discover_my_public_ip.sh
