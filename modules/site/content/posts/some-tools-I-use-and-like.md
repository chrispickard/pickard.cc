---
title: "some tools I use and like"
date: 2022-06-15T21:30:29-04:00
draft: true
---

I am very particular about my tools, everything has to work just so or it bothers me to no end. This is a short list of
tools I use and like and think you might like too.

### zsh

Where would I be without my shell? I started with [oh-my-zsh](https://ohmyz.sh/) many years ago and after looking for
faster start-up I bounced around between [prezto](https://github.com/sorin-ionescu/prezto) and
[zgen](https://github.com/tarjoilija/zgen) and probably others besides. None of them were fast enough for me. I use
[`tmux`](#tmux) and open new panes all the time. Waiting a couple seconds for the shell to load was a couple seconds too
long. I eventually left the frameworks behind for [`home-manager`](#home-manager) and now I get sub-100ms start up every
time (which is still too long, frankly). If you are also annoyed about how long zsh takes to start, [you should
profile](https://stevenvanbael.com/profiling-zsh-startup).

### tmux

I use many terminals, and I would be lost without a way to keep track of them all. A terminal off in another window
might as well not exist.
