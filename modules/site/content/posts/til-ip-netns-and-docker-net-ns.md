---
title: "TIL: docker containers don't show up in `ip netns`"
date: 2024-02-25T12:28:14-05:00
draft: false
---

a couple weeks ago I ran `ip netns` with a couple containers running and didn't see anything in the
output. this surprised me because docker is using net namespaces for network isolation. it turns out
that docker creates the netns at `/var/run/docker/netns`, while the ip command is looking in
`/run/netns`.
