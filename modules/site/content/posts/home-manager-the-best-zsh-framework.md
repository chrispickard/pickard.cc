---
title: "home manager: my favorite zsh framework"
date: 2022-11-13T17:51:32-05:00
draft: true
---

In our [last installment](../why-does-zsh-start-slowly) we talked about why `zsh` may start slowly
and what to do about it. We left off with a better understanding of how and when to profile `zsh`
startup and a common antipattern to look out for, although our solution wasn't without its 
drawbacks. Today, we are going to address those drawbacks.

### Enter home-manager

I've written about home-manager [before](../git-identity-home-manager). home-manager allows you to
declaratively define your dotfiles including all their dependencies and home-manager (using nix)
will ensure that every application you need is installed and configured just the way you like it.
home-manager includes modules for many popular tools which install and generate configuration for
that tool. One of those tools is `zsh`. Even though home-manager isn't specifically a `zsh`
framework, many `zsh` plugins are already packaged in nixpkgs (and are easy to package if they 
aren't already). The advantage of using home-manager is that it solves the problem we noticed 
with our "just write the completion to the file once and then source that completion" solution, 
namely that nix is a package manager (and thus, it knows when `kubectl` updates and it can 
prompt us to rebuild our completion script).
