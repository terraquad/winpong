const rl = @import("raylib");
const utils = @import("utils.zig");
const Position = utils.Position;
const Size = utils.Size;
const Monitor = @import("Monitor.zig");

size: Size,
monitor: Monitor,
pos: Position,

const Window = @This();
var instance: Window = undefined;
var initialized: bool = false;

pub fn new(size: Size) *Window {
    if (initialized) {
        return &instance;
    }

    rl.initWindow(size.width, size.height, "Window Pong");
    rl.setTargetFPS(60);

    instance = .{
        .size = size,
        .monitor = Monitor.current(),
        .pos = .{ .x = 0, .y = 0 },
    };
    initialized = true;

    instance.center();

    return &instance;
}

pub fn get() *Window {
    if (!initialized) @panic("no window created");
    return &instance;
}

pub fn destroy() void {
    rl.closeWindow();
    initialized = false;
}

pub fn update(self: *Window) void {
    if (!initialized) @panic("no window created");
    self.pos.x = @intFromFloat(rl.getWindowPosition().x);
    self.pos.y = @intFromFloat(rl.getWindowPosition().y);
}

pub fn setPos(self: *Window, pos: Position) void {
    if (!initialized) @panic("no window created");
    self.pos = pos;
    rl.setWindowPosition(pos.x, pos.y);
}

pub fn center(self: *Window) void {
    self.setPos(Position.center(self.monitor.size, self.size));
}

pub fn reset(self: *Window) void {
    self.* = .{
        .size = self.size,
        .monitor = Monitor.current(),
        .pos = .{ .x = 0, .y = 0 },
    };

    self.center();
}
