const std = @import("std");
const blockchain = @import("blockchain.zig");
const print = std.debug.print;
pub fn main() !void {
    const transaction = blockchain.Transaction {
        .amount = 100,
    };
    print("{}", .{ transaction.amount });
}