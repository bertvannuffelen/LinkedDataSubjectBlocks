# Testing

To validate the interactions with the target upstream systems, this directory contains a test server that can be hooked 
into the proxy to validate if the proxy configurations are working.

This does not replace a real life test, with the real upstream sytem. 
It is merely an aid to already have a quick feedback if the intentions are right.


## Test server
In this directory a dummy testserver is defined. The testserver is a Caddyserver setup, having tls disabled. 

### building the test server
The build instructions are in the `Makefile`. 

`make build` will build the test server as a local image.

The version of the test server is equal to the version set in the file ../VERSION

## testing
To test a setup, adapt the docker-compose config to match the intentional use, with the test server acting as 
the backend (upstream) system where the requests should be proxied to. 
In case of a successful configuration the request will return success (200 status) otherwise not found (404).


