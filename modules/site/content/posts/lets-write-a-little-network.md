---
title: "Let's Write a Little Network in Userspace"
date: 2022-06-15T20:57:32-04:00
draft: true
---

# What is userspace networking? 

Userspace networking means that the kernel isn't involved. When a packet shows up on the 
network card, the kernel immediately hands it to your userspace program and then washes its 
hands of it. The rest of it is up to your program.

### Ok, why would I want that?

