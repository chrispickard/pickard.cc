---
title: "rust cross compilation with zig"
date: 2022-12-28T20:58:09-05:00
draft: true
---

maybe you've heard of [`zig
cc`](https://andrewkelley.me/post/zig-cc-powerful-drop-in-replacement-gcc-clang.html)? It's the new
kid on the block that's promising painless cross compilation of C and C++ projects. It's really
cool! You can use it to painlessly [cross compile
cgo](https://dev.to/kristoff/zig-makes-go-cross-compilation-just-work-29ho)! Or, perhaps, to
cross-compile [libxml2](https://github.com/mitchellh/zig-libxml2). So, it seems like `zig cc` and 
rust are a match made in heaven. Rust gives you painless cross-compilation of pure rust and `zig 
cc` gives you an easy way to cross-compile your C/C++ dependencies. So, this should be easy, 
let's see how it goes

### the setup

```shell
cargo new --bin rust-with-zig && cd rust-with-zig

# we need a dependency that relies on a C backend
cargo add rusqlite

# we are going to target statically-linked 64-bit arm
rustup target add aarch64-unknown-linux-musl

# let's try to build it and see what happens
cargo build --target aarch64-unknown-linux-musl # whoops, it fails to build with linking errors!
```

### the first attempt

Since we are getting linking errors, let's set the linker driver (there's the linker which is
something like `ld` and then there's the linker _driver_ which is `cc`) to a version that knows how
to link aarch64 executables. If you want to know more than you'll ever want to know about 
linking a rust application, check out fasterthanlime's post on [profiling linkers]
(https://fasterthanli.me/articles/profiling-linkers).

```shell
mkdir -p .cargo
cat <<EOF >> .cargo/config
[target.aarch64-unknown-linux-musl]
linker = "zig cc -- -target aarch64-linux-musl"
EOF
```

```shell
cargo build --target aarch64-unknown-linux-musl
```

whoops, that didn't work either. it seems like cargo wants the linker arg as a single executable,
so let's write a wrapper script. make a new directory called scripts and paste the following as 
`scripts/zcc`

```shell
#!/usr/bin/env bash

# in scripts/zcc
zig cc -- -target aarch64-linux-musl -g $@
```

now, our `.cargo/config.toml` looks like this

```toml
[target.aarch64-unknown-linux-musl]
linker = "./scripts/zcc"
```

and let's try our build again

```shell
> cargo build --target aarch64-unknown-linux-musl


```
