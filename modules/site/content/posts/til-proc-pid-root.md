---
title: "TIL /proc/<pid>/root"
date: 2024-02-19T20:11:01-05:00
---

I'm starting a new series of posts called TILs. It's basically a tech only alternative to 
twitter without having to deal with mastodon. it is directly inspired by 
https://til.simonwillison.net/. We're starting out with a quick one I learned a few weeks ago.

`/proc` is a pseudo file system that contains information on every process running on the machine,
each named after the process' PID. there is much more to say about `/proc`, but today we are
interested in `/proc/<pid>/root`, which is a link to the root directory of this process pointed to
by `<pid>`. this gets interesting when you are attempting to debug a container that doesn't have a
shell. An example is

```shell
docker run -it --name nginx nginx:alpine
```

if we imagine that nginx container doesn't contain a shell, how can we debug it and look at the 
`/etc/nginx/nginx.conf`? you can enter that container's pid namespace with

```shell
docker run -it --pid container:nginx alpine
```

and then the nginx container's filesystem is available under `/proc/1/root` and the `nginx.conf` 
is at `/proc/1/root/etc/nginx/nginx.conf`
