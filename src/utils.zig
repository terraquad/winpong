pub const Position = struct {
    x: i32,
    y: i32,

    pub fn center(space_size: Size, object_size: Size) Position {
        return .{
            .x = @divTrunc(space_size.width, 2) - @divTrunc(object_size.width, 2),
            .y = @divTrunc(space_size.height, 2) - @divTrunc(object_size.height, 2),
        };
    }
};

pub const Size = struct {
    width: u31,
    height: u31,

    pub fn uniform(n: u31) Size {
        return .{ .width = n, .height = n };
    }
};
