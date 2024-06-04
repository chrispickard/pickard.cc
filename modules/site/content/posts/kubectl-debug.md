---
title: "kubectl debug for fun and zero profit"
date: 2024-05-05T14:26:13-04:00
---

One of your pods is misbehaving. Maybe it's not finding a config file or you
don't understand why it's unable to contact another pod in your cluster. At
times like these it's nice to be able to `kubectl exec` to run a command in an
existing container. Unfortunately, if you are running a container that doesn't
have a shell included (eg `FROM scratch` or similar) you are out of luck because
`kubectl exec` can't run a command that isn't already present in a container in
that pod. `kubectl run` allows you to start a container in a new pod, but not an
existing one. that's where `kubectl debug` comes in.

```shell
kubectl debug <pod name> --image <image name> -it --target <target container> -- <command to run>
```

that will start a new container in the `<pod name>` pod running `<image name>`.
this container can be started with any image, allowing you to inject debugging
tools that aren't available in a normal runtime image. since they are in the
same pod, they have access to the same namespaces available in your target
container (`coredns` in this case). This means your new container will run in
the same process namespace, the same network namespace and others. As shown in
[TIL: /proc/\<pid\>/root](./til-proc-pid-root) this allows you to look at the
filesystems of the other containers running in the pod. If you are running
coredns in your k8s cluster and want to check that the coredns configmap is
being applied to the coredns pod correctly you can run

```shell
POD_NAME=$(kubectl get pods -n kube-system -l "k8s-app=kube-dns" -o json | jq -r '.items[].metadata.name')
kubectl debug -n kube-system $POD_NAME --image busybox -it --target coredns
```

which will drop you into an ephemeral container in the coredns pod. To explore
the filesystem of the coredns container run

```shell
cd /proc/1/root
```

this is the root of the filesystem in the coredns container.

if you explore `/proc/1/` you'll find other information there as well, like the
`cmdline` the process was started with, or the environment variables that
process has access to. Any tool that is available in any image accessible from
your cluster can be used to explore the processes in that pod. You can even dump
network traffic which you can then analyze with wireshark.
