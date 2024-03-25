const std = @import("std");
const Ed25519 = std.crypto.sign.Ed25519;
const blockchain = @import("blockchain.zig");
const print = std.debug.print;

pub fn main() !void {
    var block_chain = blockchain.Chain{
        .chain = std.ArrayList(blockchain.Block).init(std.heap.page_allocator),
        .valid_zeros = 3, // 1 = 8 bits, 2 = 16 bits, 3 = 24 bits
    };
    defer block_chain.chain.deinit();
    try block_chain.init();

    var wallet_1 = blockchain.Wallet{};
    try wallet_1.init();

    var wallet_2 = blockchain.Wallet{};
    try wallet_2.init();

    print("Wallet_1: {d}\nWallet_2: {d}\n\n", .{ wallet_1.getMoney(block_chain), wallet_2.getMoney(block_chain) });

    try wallet_1.sendMoney(&block_chain, 120, wallet_2.key_pair.public_key);
    print("Wallet_1: {d}\nWallet_2: {d}\n\n", .{ wallet_1.getMoney(block_chain), wallet_2.getMoney(block_chain) });

    try wallet_2.sendMoney(&block_chain, 570, wallet_1.key_pair.public_key);
    print("Wallet_1: {d}\nWallet_2: {d}\n\n", .{ wallet_1.getMoney(block_chain), wallet_2.getMoney(block_chain) });

    try wallet_1.sendMoney(&block_chain, 90, wallet_2.key_pair.public_key);
    print("Wallet_1: {d}\nWallet_2: {d}\n\n", .{ wallet_1.getMoney(block_chain), wallet_2.getMoney(block_chain) });
}
