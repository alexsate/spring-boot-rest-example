#!/bin/bash

dirTarget=/var/jenkins_home/jobs/RSApplicationBuild/workspace/target
logStartStop=logStartStop 

chmod 777 $dirTarget/$logStartStop
chmod 777 $dirTarget/spring-boot-rest-example-*.war

> $dirTarget/$logStartStop

fuser -n tcp -k 8091 > redirection &

nohup nice java -jar $dirTarget/spring-boot-rest-example-*.war > $dirTarget/$logStartStop 2>&1 &


msgBuffer="Buffering: "
msgAppStarted="Application Started... exiting buffer!"

function watch(){

    tail -f $dirTarget/$logStartStop |

        while IFS= read line
            do
                echo "$msgBuffer" "$line"

                if [[ "$line" == *"Started Application"* ]]; then
                    echo $msgAppStarted
                    pkill  tail
                fi
        done
}

watch
