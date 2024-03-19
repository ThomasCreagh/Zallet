const std = @import("std");
const sha2 = std.crypto.hash.sha2;
pub const Transaction = struct {
    amount: u64,
    payer: u256,
    payee: u256,
};
pub const Block = struct {
    previous_hash: ?[]u8,
    transaction: Transaction,
    const timestamp: i128 = std.time.nanoTimestamp();
    pub fn hash(self: Block) [32]u8 {
        var sha256State = sha2.Sha256.init(sha2.Sha256.Options{});
        sha256State.update(std.mem.asBytes(&self));
        var digest: [32]u8 = undefined;
        sha256State.final(&digest);
        return digest;
    }
};
pub const Chain = struct {};
pub const Wallet = struct {};
