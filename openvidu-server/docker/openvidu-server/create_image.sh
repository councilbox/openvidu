cp ../../target/openvidu-server-"$1".jar ./openvidu-server.jar

docker build -t councilbox/rtmp-server .

rm ./openvidu-server.jar
