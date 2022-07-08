---
title: "just a project command center"
date: 2022-07-08T18:52:39-04:00
draft: false
---

I used to use the venerable `make(1)` as my project command runner. I would `cd` into a project I hadn't touched in
awhile, run `make test` and be off to the races. I didn't have to remember whether we used nose or pytest or whether
this was a go project or node. `make test` would do the right thing. As a person who often has several balls in the air
across several different ecosystems this is invaluable. `make`, however, is not without its warts. It was designed to
build dependencies, not to run commands. If you want to use `make` in this way you have to declare every target as
`.PHONY` which means it doesn't produce any files and that target will never be up to date (so it should run every
time). Another problem with `make` is that despite the fact that it seems to be a standard, there are many
implementations which don't all have the same features. Wikipedia has a [decent list of the disparate
implementations](https://en.wikipedia.org/wiki/Make_(software)#Derivatives).

There have been efforts to replace `make` over the years as a command runner, but I haven't found them to be that
compelling. Aside from some oddities in syntax (hope your editor is set up to only use tabs!) and the fact that writing
an if statement in makefile syntax is borderline impossible it's relatively concise. Most of its newer competitors have
decided on yaml which trades makefile's syntax oddities for yaml's, and I find yaml's to be much more pernicious. The
one exception I've found has been `just`, which takes makefile syntax, cleans it up a little and adds a ton of niceties
like built-in help (have you ever used [self-documenting make
help](https://gist.github.com/prwhite/8168133#file-makefile-L4)? I have, it's not great!), built in shell completion, it
allows you to use arguments and it has many many more features besides. In short, it's a project command center for the
21st century.

I encourage you to [check it out](https://github.com/casey/just).
