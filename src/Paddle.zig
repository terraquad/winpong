const rl = @import("raylib");
const utils = @import("utils.zig");
const Position = utils.Position;
const Size = utils.Size;
const Window = @import("Window.zig");

/// The world position (imagine the window being as large as the monitor)
world_pos: Position,
/// The actual position on screen calculated from `world_pos` in `Paddle.update()`.
/// Used for rendering the paddles.
screen_pos: Position,

color: rl.Color,
/// Is paddle on the left side of the screen?
left: bool,
controls: struct {
    key_up: rl.KeyboardKey,
    key_down: rl.KeyboardKey,
},

const Paddle = @This();

/// `world_pos` pixels to move per frame on key press
pub var velocity: i16 = 15;
/// Global paddle size for all paddles
pub var size = Size{ .width = 20, .height = 200 };

pub fn new(color: rl.Color, left: bool) Paddle {
    const win = Window.get();
    const wpos = Position{
        // Move paddle to the correct side of the world/monitor
        .x = if (left) 0 else win.monitor.size.width - size.width,
        // Move paddle (roughly) to the middle of the screen vertically
        .y = @divTrunc(win.monitor.size.height, 2),
    };
    return .{
        .world_pos = wpos,
        // Screen position gets set on first frame
        .screen_pos = .{ .x = 0, .y = 0 },
        .color = color,
        .left = left,
        .controls = .{
            .key_up = if (left) .key_w else .key_i,
            .key_down = if (left) .key_s else .key_k,
        },
    };
}

pub fn draw(self: Paddle) void {
    rl.drawRectangle(
        self.screen_pos.x,
        self.screen_pos.y,
        size.width,
        size.height,
        self.color,
    );
}

pub fn update(self: *Paddle) void {
    const win = Window.get();
    // Note that coordinates start from the top left of the monitor, so we have to...
    if (rl.isKeyDown(self.controls.key_up) and self.world_pos.y >= 0) {
        // ...decrement to get further up...
        self.world_pos.y -= velocity;
    }
    if (rl.isKeyDown(self.controls.key_down) and self.world_pos.y <= win.monitor.size.height - size.height) {
        // ...and increment to get further down.
        self.world_pos.y += velocity;
    }

    // Update the screen position
    self.screen_pos.x = self.world_pos.x - win.pos.x;
    self.screen_pos.y = self.world_pos.y - win.pos.y;
}

pub fn reset(self: *Paddle) void {
    const win = Window.get();
    const wpos = Position{
        .x = if (self.left) 0 else win.monitor.size.width - size.width,
        .y = @divTrunc(win.monitor.size.height, 2),
    };
    const spos = Position{
        .x = wpos.x - win.pos.x,
        .y = wpos.y - win.pos.y,
    };
    self.* = .{
        .world_pos = wpos,
        .screen_pos = spos,
        .color = self.color,
        .left = self.left,
        .controls = .{
            .key_up = if (self.left) .key_w else .key_i,
            .key_down = if (self.left) .key_s else .key_k,
        },
    };
}
