#!/bin/bash

# get a list of all monted filesystems, print the mountdir
for i in `mount|awk '{print $3}'`;
do
        # is it an uhurufs mount ?
        [ -z "`echo $i|grep uhurufs`" ] && continue

        # get the dir name
        dir=`dirname $i`

        # does it contain "???" (an error) ?
        if [ ! -z "`ls -la $dir 2>/dev/null | grep \?\?\?`" ];
        then
                appname=`basename $dir`

                # get a list of the apache processes which run from that dir
                for pid in `ps ax|grep $appname|awk '{print $1'}`;
                do
                        # kill the pid !
                        kill -9 $pid
                done
        fi
done
