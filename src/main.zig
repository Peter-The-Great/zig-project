// This is a simple example of a Zig program.
// You can compile it with `zig build run`.
// You can run the tests with `zig build test`.
// You can run the benchmarks with `zig build bench`.
// You can run the release build with `zig build run --release-fast`.
// You can run the optimized build with `zig build run --release-safe`.

// First we import the standard library.
const std = @import("std");

//parses the input string into a list of integers
const parseInt = std.fmt.parseInt;
pub fn main() !void {
    // Prints to stderr (it's a shortcut based on `std.io.getStdErr()`)
    std.debug.print("All your {s} are belong to us.\n", .{"codebase"});

    // stdout is for the actual output of your application, for example if you
    // are implementing gzip, then only the compressed bytes should be sent to
    // stdout, not any debugging messages.
    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();

    try stdout.print("Run `zig build test` to run the tests.\n", .{});

    try bw.flush(); // don't forget to flush!
}

test "simple test" {
    var list = std.ArrayList(i32).init(std.testing.allocator);
    defer list.deinit(); // try commenting this out and see if zig detects the memory leak!
    try list.append(42);
    try std.testing.expectEqual(@as(i32, 42), list.pop());
}
test "parse integers" {
    // The input string.
    const input = "123 67 89,99";
    // The allocator to use for the list.
    const ally = std.testing.allocator;
    // Create a list of u32s.
    var list = std.ArrayList(u32).init(ally);
    // Ensure the list is freed at scope exit.
    // Try commenting out this line!
    defer list.deinit();

    // Tokenize the input string.
    var it = std.mem.tokenize(u8, input, " ,");
    // Iterate over the tokens.
    while (it.next()) |num| {
        const n = try parseInt(u32, num, 10);
        try list.append(n);
    }
    // Check the list's length.
    const expected = [_]u32{ 123, 67, 89, 99 };
    // Check the list's contents.
    for (expected, list.items) |exp, actual| {
        try std.testing.expectEqual(exp, actual);
    }
}