# Window Pong

> Pong but you can only see what's near the ball

(made in 2 days with [raylib](https://raylib.com) and [Zig](https://ziglang.org)).

> [!NOTE]
> This game was only tested on Windows, if you experience any bugs on another system, feel free to report it.

## How to play

Blue/left player uses **W** and **S** to move up or down, red/right player uses **I** and **K**.

https://github.com/user-attachments/assets/a7677e36-ca5e-4c6d-898c-e0276de956ce

## Building

Dependencies:

- [Zig](https://ziglang.org) master
- [Git](https://git-scm.com)
- An internet connection (when building for the first time)

```sh
git clone https://github.com/terraquad/winpong.git
cd winpong

# Make a release build optimized for your computer specifically
zig build --release=small
# See build options
zig build -h
```
