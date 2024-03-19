const std = @import("std");
const blockchain = @import("blockchain.zig");
const print = std.debug.print;

pub fn main() !void {
    const transaction = blockchain.Transaction {
        .amount = 100,
        .payer = 0,
        .payee = 1,
    };
    const block = blockchain.Block {
        .previous_hash = null,
        .transaction = transaction,
    };

    print("{s}", .{ block.hash() });
}