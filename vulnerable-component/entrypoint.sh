#!/bin/sh
exec /usr/sbin/sshd -D &
exec npm start
