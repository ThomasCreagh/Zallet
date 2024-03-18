const std = @import("std");
pub const Transaction = struct {
    amount: usize,
    payer: []const u8,
    payee: []const u8,
};
const Block = struct {
    previous_hash: []u8,
    transaction: Transaction,
    const timestamp: i128 = std.time.nanoTimestamp();
    pub fn hash(self: Block) u256 {
        return std.crypto.hash.sha2.Sha256(self);
    }
};
const Chain = struct {};
const Wallet = struct {};
