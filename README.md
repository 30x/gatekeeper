## Install

### Prerequisites

1. Install openresty (nginx w/ luajit & luasec)
  * On a Mac, run `brew update && brew install homebrew/nginx/openresty && brew intall glide`.
  * For other platforms, visit the [installation page](http://openresty.org/en/installation.html) for installation details.

### Either build from source

1. `git clone https://github.com/30x/gatekeeper.git`.
2. `cd gatekeeper` and run `make` install Lua libs and build the shared lib.

### Or download a release

1. Download a [release](https://github.com/30x/gatekeeper/releases) from Github and unzip.

## Configure

1. Edit `nginx/nginx.conf` and modify the paths around line 22 to match the paths on your system:
  ```
  local handlers = {
      dump = 'file:///Users/sganyo/dev/gatekeeper/pipes/dump.yaml',
      apikey = 'file:///Users/sganyo/dev/gatekeeper/pipes/apikey.yaml'
  }
  ```

2. Run `./start.sh` to start nginx (openresty must be on the path)
  * Note: If you receive an error: `nginx: [warn] 7168 worker_connections exceed open file resource limit`, increase your resource limit with the command `ulimit -n 7168`


You should now be able to run a pipe:
1. Run `curl localhost:9000`. You should see a response like `Hello, Guest!`
2. Look at run/error.log. You should see request and response logging from the `dump` plugin.

## Stop the server

1. Run `./stop.sh` to stop openresty

## Customizing

For custom configuration, change the following:

1. `nginx/nginx.conf` for host/path definitions and assignment
2. `pipes/default.yaml` for pipe definitions
3. `plugins/plugins.go` to add plugins

Note: If you add plugins, you'll need to run `make` again.
