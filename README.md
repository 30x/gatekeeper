## Setup

1. Install openresty (nginx w/ luajit & luasec)
2. Run `make` to install lua libs and build the shared lib
3. Run `./start.sh` to start nginx (openresty must be on the path)

Your should now be able to run the default pipe. Try `curl localhost:9002`

1. Run `./stop.sh` to stop nginx

For custom configuration, change the following:

1. `nginx/nginx.conf` for host/path definitions
2. `pipes/default.yaml` for pipe definitions
3. `plugins/plugins.go` to add plugins

Note: If you add plugins, you'll need to run `make` again.
