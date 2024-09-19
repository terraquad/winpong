const rl = @import("raylib");
const utils = @import("utils.zig");
const Position = utils.Position;
const Size = utils.Size;
const Window = @import("Window.zig");
const Paddle = @import("Paddle.zig");

/// The ball position on the screen (static, always in the middle)
render_pos: Position,
/// The in-world position of the ball (see Paddle `world_pos`)
pos: Position,
size: u31,
flipped_x: bool = false,
flipped_y: bool = false,

const Ball = @This();

pub var velocity: i16 = 10;

pub fn new(size: u31) Ball {
    const win = Window.get();
    return .{
        .render_pos = Position.center(win.size, Size.uniform(size)),
        .pos = Position.center(win.size, Size.uniform(size)),
        .size = size,
    };
}

pub fn draw(self: Ball) void {
    rl.drawRectangle(
        self.render_pos.x,
        self.render_pos.y,
        self.size,
        self.size,
        rl.Color.white,
    );
}

pub fn update(self: *Ball) void {
    var win = Window.get();

    // Move ball
    self.pos.x += if (self.flipped_x) -velocity else velocity;
    self.pos.y += if (self.flipped_y) -velocity else velocity;
    // Figure out if the ball should bounce off the side of the screen
    if (self.pos.y < -self.render_pos.y) {
        self.flipped_y = false;
    } else if (self.pos.y > win.monitor.size.height - self.render_pos.y - self.size) {
        self.flipped_y = true;
    }

    // Move the window to the balls' world position
    win.setPos(self.pos);
}

pub fn collide_and_flip(self: *Ball, paddle: Paddle) void {
    if (self.collide(paddle)) {
        self.flipped_x = !paddle.left;
    }
}

/// Checks if this ball intersects with the paddle.
pub fn collide(self: Ball, paddle: Paddle) bool {
    const same_horizontal =
        self.pos.y + self.render_pos.y >= paddle.world_pos.y and
        self.pos.y + self.render_pos.y <= paddle.world_pos.y + Paddle.size.height;
    const same_vertical = switch (paddle.left) {
        true => self.pos.x + self.render_pos.x <= paddle.world_pos.x,
        false => self.pos.x + self.render_pos.x + self.size >= paddle.world_pos.x,
    };
    return same_horizontal and same_vertical;
}

/// Returns `true` if the paddle has missed the ball
pub fn check_for_loser(self: Ball, paddle: Paddle) bool {
    const win = Window.get().*;
    // Find center of the ball
    const death_point = self.pos.x + self.render_pos.x + @divTrunc(self.size, 2);

    if ((paddle.left and death_point < 0) or
        (!paddle.left and death_point > win.monitor.size.width))
    {
        return true;
    }

    return false;
}

pub fn reset(self: *Ball) void {
    const win = Window.get();
    self.* = .{
        .render_pos = Position.center(win.size, Size.uniform(self.size)),
        .pos = Position.center(win.size, Size.uniform(self.size)),
        .size = self.size,
    };
}
