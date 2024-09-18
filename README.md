# Window Pong

> Pong but you can only see what's near the ball

(made in 2 days with [raylib](https://raylib.com) and [Zig](https://ziglang.org)).

> [!NOTE]
> This game was only tested on Windows, if you experience any bugs on another system, feel free to report it.

## How to play

Blue/left player uses **W** and **S** to move up or down, red/right player uses **I** and **K**.

## Building

Dependencies:

- [Zig](https://ziglang.org) master
- [Git](https://git-scm.com)
- An internet connection

```sh
git clone https://github.com/terraquad/winpong.git
cd winpong

# Make a release build optimized for your computer specifically
zig build --release=small
# See build options
zig build -h
```

> [!IMPORTANT]
> Cross-compilation currently doesn't work due to Raylib linking to system libraries (tested on Linux over WSL).
