# JSON Server

## How to build image

```shell
docker image build . --no-cache -t json-server
```
* `--no-cache` option every time the build start gets fresh copy from docker hub. 
* `-t` option create a unique tag insisted of using image hash ID.

## How to run this image using container

```shell
docker run --rm -p 4000:3000 json-server
```
* `--rm` option tells docker engine to remove the contianer after it stop.
* `json-server` argument is the image unique tag setup when builoding this image.
