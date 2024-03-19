const std = @import("std");
const blockchain = @import("blockchain.zig");
const print = std.debug.print;

pub fn main() !void {
    var block_chain = blockchain.Chain{
        .chain = std.ArrayList(blockchain.Block).init(std.heap.page_allocator),
    };
    defer block_chain.chain.deinit();
    try block_chain.init();
    print("{any}\n\n{s}\n\n", .{ block_chain.getLastBlock(), block_chain.getLastBlock().hash() });
    try block_chain.add(blockchain.Transaction{
        .amount = 1000,
        .payer = 2,
        .payee = 3,
    });
    // try block_chain.add(blockchain.Transaction{
    //     .amount = 2000,
    //     .payer = 4,
    //     .payee = 5,
    // });
    print("{any}\n\n{s}\n\n", .{ block_chain.getLastBlock(), block_chain.getLastBlock().hash() });
    // const transaction = blockchain.Transaction{
    //     .amount = 100,
    //     .payer = 0,
    //     .payee = 1,
    // };
    // const block = blockchain.Block{
    //     .previous_hash = .{ 179, 80, 195, 27, 12, 237, 177, 234, 93, 6, 230, 56, 51, 229, 122, 37, 159, 118, 119, 58, 88, 105, 117, 38, 146, 57, 24, 177, 135, 9, 229, 243 },
    //     .transaction = transaction,
    // };

    // print("{s}", .{ block.hash() });
}
