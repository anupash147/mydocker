

function logs {
    $SUDO docker ps | awk '{print $1}' | tail -1 | xargs -I % docker logs %
}

function terminal {
    var=`$SUDO docker ps | awk '{print $1}' | tail -1 `
    $SUDO docker exec -it ${var} /bin/bash
}
function logsf {
    $SUDO docker ps | awk '{print $1}' | tail -1 | xargs -I % docker logs % -f
}
