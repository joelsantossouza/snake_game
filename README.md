# Snake Assembly Practice

A learning project written in x86 assembly for Linux. This repository is focused on practicing assembly programming techniques rather than delivering a polished game.

https://github.com/user-attachments/assets/912eabcb-a932-455d-afeb-8f3f1c30df42

## Overview

The code implements a simple Snake-like experience using only Linux syscalls for terminal I/O. The main goal is to explore low-level program structure, game state management, and assembly-language organization.

## Learning Goals

- Practice x86 assembly structure and control flow
- Manage game state directly in memory
- Use syscall-based terminal input/output
- Keep configuration separate using include files

## Repository Structure

- `src/` — assembly source files for gameplay, input handling, map logic, and utilities
- `include/snake.inc` — game configuration values, constants, and settings

## Build

```sh
make
```

## Run

```sh
./snake
```

## Gameplay Goal

The objective is to collect all food until the snake fills the play area defined by the map configuration.
