cp ../../target/openvidu-server-"$1".jar ./openvidu-server.jar

docker build -t councilbox/server-java .

rm ./openvidu-server.jar
