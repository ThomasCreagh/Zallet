const std = @import("std");
const blockchain = @import("blockchain.zig");
const print = std.debug.print;

pub fn main() !void {
    var block_chain = blockchain.Chain{
        .chain = std.ArrayList(blockchain.Block).init(std.heap.page_allocator),
    };
    defer block_chain.chain.deinit();
    try block_chain.init();
    try block_chain.add(blockchain.Transaction{
        .amount = 1000,
        .payer = 2,
        .payee = 3,
    });
    try block_chain.add(blockchain.Transaction{
        .amount = 2000,
        .payer = 4,
        .payee = 5,
    });
    var wallet = blockchain.Wallet{};
    try wallet.init();
    print("Wallet: {any}\n\n", .{ wallet });
}
