hugo_dir := "modules/site"

_default:
  @just --list --unsorted

new-post post:
  cd {{hugo_dir}} && hugo new "posts/{{post}}.md"

serve:
  cd {{hugo_dir}} && hugo server

serve-drafts:
  cd {{hugo_dir}} && hugo server -D

deploy:
  scripts/deploy
