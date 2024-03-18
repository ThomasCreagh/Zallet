const std = @import("std");
const blockchain = @import("blockchain.zig");
const print = std.debug.print;

pub fn main() !void {
    const transaction = blockchain.Transaction {
        .amount = 100,
        .payer = "Alice",
        .payee = "Bob",
    };
    print("{} {s} {s}", .{ transaction.amount, transaction.payer, transaction.payee });
}