## Setup

1. Install openresty (nginx w/ luajit & luasec)
  * On a mac you can simply run `brew update && brew install homebrew/nginx/openresty`
  * On any other platform, you will need to [visit the installation page.](http://openresty.org/en/installation.html) for installation details
1. Run `make` to install lua libs and build the shared lib
1. Edit `nginx/nginx.conf` and modify this path to be an absolute path on your system.
  ```
  local handlers = {
      default = 'file:///Users/apigee/develop/go/src/github.com/30x/zuul/pipes/default.yaml'
    }
  ```
1. Run `./start.sh` to start nginx (openresty must be on the path)
  * If you receive this error
  `nginx: [warn] 10240 worker_connections exceed open file resource limit: <some number>`
  Increase your resource limit with the command `ulimit -n 10240`


Your should now be able to run the default pipe. Try `curl localhost:9000`

1. Run `./stop.sh` to stop nginx

For custom configuration, change the following:

1. `nginx/nginx.conf` for host/path definitions
2. `pipes/default.yaml` for pipe definitions
3. `plugins/plugins.go` to add plugins

Note: If you add plugins, you'll need to run `make` again.
