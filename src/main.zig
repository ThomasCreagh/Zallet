const std = @import("std");
const Ed25519 = std.crypto.sign.Ed25519;
const blockchain = @import("blockchain.zig");
const print = std.debug.print;

pub fn main() !void {
    var block_chain = blockchain.Chain{
        .chain = std.ArrayList(blockchain.Block).init(std.heap.page_allocator),
        .valid_zeros = 3,
    };
    defer block_chain.chain.deinit();
    try block_chain.init();
    var wallet_1 = blockchain.Wallet{};
    try wallet_1.init();
    var wallet_2 = blockchain.Wallet{};
    try wallet_2.init();
    try wallet_1.sendMoney(&block_chain, 100, wallet_2.key_pair.public_key);
    print("Wallet: {any}\n\n", .{ wallet_2 });
}