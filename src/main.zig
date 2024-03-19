const std = @import("std");
const blockchain = @import("blockchain.zig");
const print = std.debug.print;

pub fn main() !void {

    var block_chain = blockchain.Chain{
        .chain = std.ArrayList(blockchain.Block).init(std.heap.page_allocator),
    };
    defer block_chain.chain.deinit();
    try block_chain.init();

    print("{any}", .{block_chain.getLastBlock()});
}
