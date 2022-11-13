---
title: "why does zsh start so slowly?"
date: 2022-11-12T16:22:03-05:00
---

I'm serious about shell startup speed. I use [tmux](https://github.com/tmux/tmux) to open and
close tmux splits all day every day, so I need `zsh` to start quickly. I used to use frameworks
like [oh-my-zsh](https://ohmyz.sh/) or [prezto](https://github.com/sorin-ionescu/prezto) and
while I was happy with the functionality they provided I wasn't happy with their impact on my
shell's startup speed. So, what do we do about it? The first step when something _feels_ slow is
to validate that it _is_ slow; we need to profile!

### Profiling

Almost everything I know about profiling `zsh` came from Steven Van Bael's article on [Profiling zsh
startup time](https://stevenvanbael.com/profiling-zsh-startup). You should hop over there and read
the article for more, but the tl;dr is to add `zmodload zsh/zprof` at the very top of your `~/.
zshrc` and `zprof` to the very bottom, then restart the shell. On startup, you will see a table with
everything impacting your shell startup time. When I profiled my shell, many of the worst offenders
came from those frameworks and the plugins they bundle. This was several years ago, and they may
have refactored in the years since, so you should always profile before making changes and then
profile again at each step. Allow the profile to guide you! When you are done profiling, simply
remove `zmodload zsh/zprof` and `zprof` from your `~/.zshrc`.

### The Problem

So, why is `zsh` slow to start in the first place? if you run `zsh -i -d -f -l` which gives you an
interactive login shell without interpreting your `~/.zshrc`, you'll see that `zsh` starts nearly
instantaneously, though without any customizations. The biggest culprit that slows down `zsh`
startup is forcing zsh to source the output of a command. So, for example, if you look at the
kubernetes docs on how to set up [kubectl zsh
autocompletion](https://kubernetes.io/docs/tasks/tools/included/optional-kubectl-configs-zsh/),
you'll see that they recommend you run

```shell
 source <(kubectl completion zsh) 
```

This is an antipattern. On my machine running `time kubectl completion zsh` takes 130ms! I want my
shell to start in well under 100ms and running just one binary already blew that budget. `zsh`
_cannot_ cache this because to the shell it's a dynamic output that could change at any time.
Often, this is how plugins in typical frameworks work, they find and load the plugins they need
at runtime, rather than allowing them to be cached as static files.

### The Solution (sorta!)

Since `zsh` can't cache a dynamic binary what should we do? Make it a static file.

```shell
 mkdir -p ~/.zsh/plugins/kubectl/
 kubectl completion zsh > ~/.zsh/plugins/kubectl/_kubectl
 
 # in ~/.zshrc
 autoload -U compinit && compinit # loads the zsh completion initialization module, only 
 # do this once, if you are already loading completions you don't need to add this again
 source ~/.zsh/plugins/kubectl/_kubectl # this loads the completion
```

Now that the completion is just a file it's easy for `zsh` to cache. There is a downside to this
approach though, what happens when kubectl adds new options or changes their completion? Thankfully
cache invalidation is a [famously easy problem to
solve](https://twitter.com/codinghorror/status/506010907021828096).

### Conclusion

Today we learned about profiling and common antipatterns that can slow down shell startup. Next
time we will learn how to fix our issues with cache invalidation that leave us open to incorrect
completions in our shell and the framework I use to solve these problems.
