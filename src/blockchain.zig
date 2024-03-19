const std = @import("std");
const sha2 = std.crypto.hash.sha2;
pub const Transaction = struct {
    amount: u64,
    payer: u256,
    payee: u256,
};
pub const Block = struct {
    previous_hash: ?[32]u8,
    transaction: Transaction,
    pub fn hash(self: Block) [32]u8 {
        var sha256State = sha2.Sha256.init(sha2.Sha256.Options{});
        std.debug.print("BYTES: {any}\n\n", .{ std.mem.asBytes(&self) });
        sha256State.update(std.mem.asBytes(&self));
        var digest: [32]u8 = undefined;
        sha256State.final(&digest);
        return digest;
    }
};
    // const timestamp: i128 = std.time.nanoTimestamp();
pub const Chain = struct {
    chain: std.ArrayList(Block),
    pub fn init(self: *Chain) !void {
        try self.chain.append(Block{ .previous_hash = null, .transaction = Transaction{
            .amount = 100,
            .payer = 0,
            .payee = 1,
        } });
    }
    pub fn add(self: *Chain, transaction: Transaction) !void {
        try self.chain.append(Block{
            .previous_hash = self.getLastBlock().hash(),
            .transaction = transaction,
        });
    }
    pub fn getLastBlock(self: Chain) Block {
        return self.chain.getLast();
    }
};
pub const Wallet = struct {};
