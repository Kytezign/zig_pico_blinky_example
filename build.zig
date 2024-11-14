const std = @import("std");
const MicroZig = @import("microzig/build");
const rp2xxx = @import("microzig/port/raspberrypi/rp2xxx");

pub fn build(b: *std.Build) !void {
    const mz = MicroZig.init(b, .{});
    const optimize = b.standardOptimizeOption(.{});

    // `add_firmware` basically works like addExecutable, but takes a
    // `microzig.Target` for target instead of a `std.zig.CrossTarget`.
    //
    // The target will convey all necessary information on the chip,
    // cpu and potentially the board as well.
    const firmware = mz.add_firmware(b, .{
        .name = "blink",
        .target = rp2xxx.boards.raspberrypi.pico,
        .optimize = optimize,
        .root_source_file = b.path("src/main.zig"),
    });

    // `install_firmware()` is the MicroZig pendant to `Build.installArtifact()`
    // and allows installing the firmware as a typical firmware file.
    //
    // This will also install into `$prefix/firmware` instead of `$prefix/bin`.
    mz.install_firmware(b, firmware, .{});

    // For debugging, we also always install the firmware as an ELF file
    mz.install_firmware(b, firmware, .{ .format = .elf });
}
