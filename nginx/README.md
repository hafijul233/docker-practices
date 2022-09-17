# NGINX Server

## How to build image

```shell
docker image build . --no-cache -t plain-nginx
```
* `--no-cache` option every time the build start gets fresh copy from docker hub. 
* `-t` option create a unique tag insisted of using image hash ID.


## How to run this image using container

```shell
docker run --rm -p 8080:80 plain-nginx
```
* `--rm` option tells docker engine to remove the contianer after it stop.
* `plain-nginx` argument is the image unique tag setup when builoding this image.

> Now while on browser you will get an 403 error. because you didn't pointed any source location to fix it add source location like

```shell
docker run --rm -p 8080:80 -v $(pwd)/src:/var/www/html plain-nginx
```
* `$(pwd)` argument isert the current working directory of host machine
* `-v` define how the host volumne is treated as on container location kind of shortcut