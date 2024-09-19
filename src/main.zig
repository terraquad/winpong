const rl = @import("raylib");
const Size = @import("utils.zig").Size;
const Window = @import("Window.zig");
const Paddle = @import("Paddle.zig");
const Ball = @import("Ball.zig");

fn drawWinnerText(left: bool) void {
    rl.clearBackground(rl.Color.black);

    const win = Window.get();
    const text = if (left) "Blue won!" else "Red won!";
    const color = if (left) rl.Color.sky_blue else rl.Color.orange;
    const txt_size = rl.measureTextEx(rl.getFontDefault(), if (left) "Blue won!" else "Red won!", 64, 5);
    // Draw centered winning text
    rl.drawText(
        text,
        @divTrunc(win.size.width, 2) - @divTrunc(@as(i32, @intFromFloat(txt_size.x)), 2),
        @divTrunc(win.size.height, 2) - @divTrunc(@as(i32, @intFromFloat(txt_size.y)), 2),
        64,
        color,
    );
}

pub fn main() !void {
    var win = Window.new(Size.uniform(1000));
    defer Window.destroy();

    var ball = Ball.new(50);
    var paddle_blue = Paddle.new(rl.Color.blue, true);
    var paddle_red = Paddle.new(rl.Color.red, false);

    // Pause frames
    var pframes: i16 = -1;
    // When `pframes > 0`, won won?
    var winner_left: bool = false;

    while (!rl.windowShouldClose()) {
        rl.beginDrawing();
        defer rl.endDrawing();

        // Should the game be paused?
        if (pframes > 0) {
            drawWinnerText(winner_left);
            pframes -= 1;
            continue;
        }

        // Rendering
        rl.clearBackground(rl.Color.black);
        ball.draw();
        paddle_blue.draw();
        paddle_red.draw();

        // State updates
        win.update();
        ball.update();
        paddle_blue.update();
        paddle_red.update();

        // Collisions
        ball.collide_and_flip(paddle_blue);
        ball.collide_and_flip(paddle_red);

        const anyone_won = ball.check_for_loser(paddle_red) or ball.check_for_loser(paddle_blue);
        if (anyone_won) {
            pframes = 120; // Show win screen for 120 frames or 2 seconds
            winner_left = ball.check_for_loser(paddle_red);
            // Reset game state
            win.reset();
            ball.reset();
            paddle_blue.reset();
            paddle_red.reset();
        }
    }
}
