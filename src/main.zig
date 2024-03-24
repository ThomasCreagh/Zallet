const std = @import("std");
const Ed25519 = std.crypto.sign.Ed25519;
const blockchain = @import("blockchain.zig");
const print = std.debug.print;

pub fn main() !void {
    var block_chain = blockchain.Chain{
        .chain = std.ArrayList(blockchain.Block).init(std.heap.page_allocator),
    };
    defer block_chain.chain.deinit();
    try block_chain.init();
    var wallet_1 = blockchain.Wallet{};
    try wallet_1.init();
    var wallet_2 = blockchain.Wallet{};
    try wallet_2.init();
    try wallet_1.sendMoney(&block_chain, 100, wallet_2.key_pair.public_key);
    // const key_bytes: [Ed25519.PublicKey.encoded_length]u8 = undefined; 
    // const key_ED25519 = try Ed25519.PublicKey.fromBytes(key_bytes);
    // try block_chain.add(blockchain.Transaction{
    //     .amount = 1000,
    //     .payer = key_ED25519,
    //     .payee = key_ED25519,
    // });
    // try block_chain.add(blockchain.Transaction{
    //     .amount = 2000,
    //     .payer = key_ED25519,
    //     .payee = key_ED25519,
    // });
    print("Wallet: {any}\n\n", .{ wallet_2 });
}