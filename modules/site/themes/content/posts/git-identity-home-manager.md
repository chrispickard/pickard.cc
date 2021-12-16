---
title: "multiple git identities with home-manager and fzf"
date: 2021-12-15T15:52:06-05:00
---

If you have multiple git identities (a personal and a work email, say)
and would like to use both in different projects on the same machine it
can be a hassle. Hopefully you\'ve never committed to your work repo
with your personal email address! If this happens you\'re looking at an
unwieldy [git filter-branch
invocation](https://serverfault.com/a/13162/360506) to fix it.

To avoid the issue in the future you can use a feature of git called
[conditional includes](https://stackoverflow.com/a/43654115/3511790),
but I still find them easy to forget to include in each repo that needs
a different identity (and I don\'t use a separate `~/dev/work` and
`~/dev/personal` so there isn\'t a good place to set and forget them). I
found the solution that works best for me in [a blog post by Micah
Henning](https://www.micah.soy/posts/setting-up-git-identities/). You
should go check it out, but I\'m quoting the first paragraph because it
is almost exactly the solution I was looking for.

> Working on many projects across multiple identities can be difficult
> to manage. This is a procedure for leveraging git aliases to set an
> identity at the project level for any project with support for
> GPG-based commit signing.

Henning\'s needs include PGP which I won\'t be touching on here, but my
approach will work if you do need pgp keys as well. The other difference
is that I use
[home-manager](https://github.com/nix-community/home-manager) which
allow you to declaratively define all your dotfiles including their
dependencies (copy your `home.nix` to a new machine and watch as
everything is setup just the way you want it, it\'s magical the first
time you see it work). home-manager uses [nix](https://nixos.org/) as a
package manager. The downside (such as it is) is that nix wants
everything in the nix language so that it can track it and give you
atomic upgrades and painless rollbacks.

So, with the table-setting out of the way, how did I combine the ideas
of the git config in Henning\'s blog post with the git support in
home-manager? It starts with a `home.nix` that contains at least

`home.nix`:

``` nix
{ config, pkgs, ... }:

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  targets.genericLinux.enable = true;

  imports = [
    ./git
  ];
  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "20.03";
}

```

The important piece here is:

``` nix
imports = [
  ./git
];
```

when you import `./git` in your `home.nix` it will attempt to import the
file called `default.nix` from that directory.

`git/default.nix`:

``` nix
{ config, lib, pkgs, ... }:

{
  # we will use the excellent fzf in our `git-identity` script, so let's make sure it's available
  home.packages = with pkgs; [ fzf ];
  programs.git = {
    enable = true;
    extraConfig = {
      # extremely important, otherwise git will attempt to guess a default user identity. see `man git-config` for more details
      user.useConfigOnly = true;

      # the `work` identity
      user.work.name = "Spider-Man";
      user.work.email = "friendlyspidey@neighborhood.com";

      # the `personal` identity
      user.personal.name = "Peter Parker";
      user.personal.email = "peter@parker.com";
      # I think spider-man might be peter parker! somebody get j jonah jameson on the line
    };
    aliases = {
      identity = "! git-identity";
      id = "! git-identity";
    };
  };

  home.file."bin/git-identity" = {
    source = ./git-identity;
    executable = true;
  };

}
```

the `default.nix` relies on a script called `git-identity`

``` nix
home.file."bin/git-identity" = {
  source = ./git-identity;
  executable = true;
};
```

so let\'s go ahead and create it. It is also in the `./git` directory

`git/git-identity`:

```shell
#!/usr/bin/env bash

# get each set of usernames from the git config (which will be generated from our `default.nix` above)
IDENTITIES=$(git config --global --name-only --get-regexp "user.*..name" | sed -e 's/^user.//' -e 's/.name$//')
# filter them with fzf
ID=$(echo "${IDENTITIES}" | fzf -e -1 +m -q "$1")
if ! git config --global --get-regexp "user.${ID}.name" > /dev/null; then
    echo "Please use a valid git identity
Options:"
    git config --global --name-only --get-regexp "user.*..name" | sed -e 's/^user.//' -e 's/.name$//' -e 's/^/\t/'
    exit 1
fi
# set the ID locally in each repo (eg in the repo's .git/config)
git config user.name "$(git config user.${ID}.name)"
git config user.email "$(git config user.${ID}.email)"

echo "Name: $(git config user.name)"
echo "Email: $(git config user.email)"
```

To make that all a little more concrete, once that is all in your
`home.nix` and `./git`, run

```shell
home-manager switch
```

and attempt to commit something to your favorite repo

```shell
» git commit
Author identity unknown

*** Please tell me who you are.

Run

  git config --global user.email "you@example.com"
  git config --global user.name "Your Name"

to set your account's default identity.
Omit --global to set the identity only in this repository.

fatal: no email was given and auto-detection is disabled
```

simply type `git identity` to get an `fzf`-powered list of all your various identities.
