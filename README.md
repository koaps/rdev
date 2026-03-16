# rdev
Remote Development Container

This is the container image I use as a SSH target for development.

It's designed to work in my [devstack](https://github.com/koaps/devstack) environment, mainly pulling pip packages from the local mirror and using the DB services.

I'm working learning some Javascript right now, so it has NPM installing some packages when run, you can edit the boot.sh to turn that off.

The way I use this image is having drone build it and then run `docker-compose up` to create the container, after that I can ssh to it directly or via vscode.

You can run make manually to do the same thing:
```
make
make up
```

# Docker Server
If you are using my [devstack](https://github.com/koaps/devstack) environment, make sure your docker server trusts the local docker registry or you can't push/pull to it and drone might not use caches when building, it takes a very long time to build from scratch.
```
jq . /etc/docker/daemon.json
{
  "insecure-registries": [
    "172.16.16.1:5000"
  ]
}
```
