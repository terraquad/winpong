const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const strip = b.option(bool, "strip", "Remove debug info") orelse false;
    const no_console = b.option(bool, "no_console", "Disable logging on Windows") orelse false;

    const exe = b.addExecutable(.{
        .name = "winpong",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
        .strip = strip,
    });
    b.installArtifact(exe);

    if (no_console) exe.subsystem = .Windows;

    const raylib_dep = b.dependency("raylib-zig", .{
        .target = target,
        .optimize = optimize,
    });
    exe.root_module.addImport("raylib", raylib_dep.module("raylib"));
    const rl_lib = raylib_dep.artifact("raylib");
    exe.linkLibrary(rl_lib);

    const run_exe = b.addRunArtifact(exe);
    run_exe.step.dependOn(b.getInstallStep());
    const run_step = b.step("run", "Run WinPong");
    run_step.dependOn(&run_exe.step);
}
