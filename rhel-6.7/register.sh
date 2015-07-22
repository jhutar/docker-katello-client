#!/bin/bash
# author: Pavel Studenik <pstudeni@redhat.com>

# register.sh <username> <password> <server>

RHN_USER=${1:-$RHN_USER}
RHN_PASS=${2:-$RHN_PASS}
RHN_ORG=${3:-$RHN_ORG}
RHN_SERVER=${4:-$RHN_SERVER}

# Make sure we have DBus running, othervise SM complains with:
# DBusException: org.freedesktop.DBus.Error.FileNotFound: Failed to connect to socket /var/run/dbus/system_bus_socket: No such file or directory
service messagebus status || service messagebus start

rpm -Uvh http://$RHN_SERVER/pub/katello-ca-consumer-latest.noarch.rpm

subscription-manager register --username="$RHN_USER" --password="$RHN_PASS" --org="$RHN_ORG" --environment="Library" --auto-attach

[ $? -ne 0 ] && tail /var/log/rhsm/rhsm.log

# TODO: Deal with katello-agent
###yum -y install katello-agent

yum repolist
