tutum-docker-riak
=================

Base docker image to run a riak database server


Usage
-----

To create the image `tutum/riak`, execute the following command on the tutum-riak folder:

        docker build -t tutum/riak .


Running the riak server
--------------------------

Run the following command to start riak:

        docker run -d -p 8087:8087 -p 8098:8098 tutum/riak

The first time that you run your container, a new random password will be set.
To get the password, check the logs of the container by running:

        docker logs <CONTAINER_ID>

You will see an output like the following:

        ========================================================================
        You can now use riak Server using:
        
          wget --no-check-certificate -qO- https://riakuser:FVPNf35hXeXG@host:port/ping
        
        Or use protocol buffer with same user/password.
        
        Please remember to change the above password as soon as possible!
        You must use https protocol. http is disable for security reasons
        ========================================================================

In this case, `FVPNf35hXeXG` is the password set. 
You can then connect to riak (using API):

        wget --no-check-certificate -qO- https://riakuser:FVPNf35hXeXG@host:port/  

Done!


Setting a specific password for the riakuser account
-------------------------------------------------

If you want to use a preset password instead of a randomly generated one, you can
set the environment variable `RIAK_PASS` to your specific password when running the container:

        docker run -d -p 8087:8087 -p 8098:8098 -e RIAK_PASS="mypass" tutum/riak

You can now test your new admin password:

        wget --no-check-certificate -qO- https://riakuser:mypass@host:port/  

Using riak with Protocol Buffers
--------------------------------

Remember that you can use Protocol Buffer to connect riak. You must use same user and password
that it's generated random (or set in ENV) but using Protocol Buffer port 8087.
