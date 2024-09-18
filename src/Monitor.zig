const rl = @import("raylib");
const utils = @import("utils.zig");
const Position = utils.Position;
const Size = utils.Size;

id: i32,
size: Size,
pos: Position,

const Monitor = @This();

pub fn new(id: i32) Monitor {
    return .{
        .id = id,
        .size = .{
            .width = @intCast(rl.getMonitorWidth(id)),
            .height = @intCast(rl.getMonitorHeight(id)),
        },
        .pos = .{
            .x = @intCast(@as(i32, @intFromFloat(rl.getMonitorPosition(id).x))),
            .y = @intCast(@as(i32, @intFromFloat(rl.getMonitorPosition(id).y))),
        },
    };
}

pub fn current() Monitor {
    return new(rl.getCurrentMonitor());
}
