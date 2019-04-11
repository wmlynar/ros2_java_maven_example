#!/bin/bash

PARAMS=$@

ROS_DOMAIN_ID=
LD_LIBRATY_PATH=/opt/ros2_java/lib:$LD_LIBRATY_PATH
DOCKER_IMAGE=ros1_ros2_ros2javalibs_opensplice
RMW_IMPLEMENTATION=rmw_opensplice_cpp
NETWORK_INTERFACE=lo
#OPENSPLICE_CONFIG_FILE=/usr/etc/opensplice/config/ospl.xml
OPENSPLICE_CONFIG_FILE=/root/ros2_install/ros2-linux/share/opensplice_cmake_module/config/ros_ospl.xml
OSPL_ERRORFILE="<stderr>"
OSPL_HOME=/usr
OSPL_INFOFILE="<stdout>"
OSPL_TMPL_PATH=/usr/etc/opensplice/idlpp
OSPL_URI=file://$OPENSPLICE_CONFIG_FILE
OSPL_VERBOSITY=WARNING

# commenting this out saves a lot of time
#        . ~/ros2_install/ros2-linux/local_setup.bash &&\

docker run --rm --net=host -v "$(pwd):/work" -w "/work" -it $DOCKER_IMAGE bash -c "\
        export _KILL_ME=$_KILL_ME &&\
        export ROS_DOMAIN_ID=$ROS_DOMAIN_ID &&\
        export RMW_IMPLEMENTATION=$RMW_IMPLEMENTATION &&\
        export _JAVA_OPTIONS=\"$_JAVA_OPTIONS\" &&\
	export OSPL_ERRORFILE=\"$OSPL_ERRORFILE\" &&\
        export OSPL_HOME=$OSPL_HOME &&\
        export OSPL_INFOFILE=\"$OSPL_INFOFILE\" &&\
        export OSPL_TMPL_PATH=$OSPL_TMPL_PATH &&\
        export OSPL_URI=$OSPL_URI &&\
        export OSPL_VERBOSITY=$OSPL_VERBOSITY &&\
        perl -i -pe 'BEGIN{undef $/;} s/<Id>[^<]*<\/Id>/<Id>$ROS_DOMAIN_ID<\/Id>/smg' $OPENSPLICE_CONFIG_FILE &&\
        perl -i -pe 'BEGIN{undef $/;} s/<NetworkInterfaceAddress>[^<]*<\/NetworkInterfaceAddress>/<NetworkInterfaceAddress>$NETWORK_INTERFACE<\/NetworkInterfaceAddress>/smg' $OPENSPLICE_CONFIG_FILE &&\
        java -jar target/ros2-java-maven-example-*-SNAPSHOT-jar-with-dependencies.jar $PARAMS"
