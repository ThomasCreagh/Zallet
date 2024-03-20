const std = @import("std");
const crypto = std.crypto;
const Sha256 = crypto.hash.sha2.Sha256;
const Ed25519 = crypto.sign.Ed25519;
const asBytes = std.mem.asBytes;

pub const Transaction = struct {
    amount: u64,
    payer: u256,
    payee: u256,
};
pub const Block = struct {
    previous_hash: ?[32]u8,
    transaction: Transaction,
    timestamp: i128,
    pub fn hash(self: Block) [32]u8 {
        var sha256State = Sha256.init(Sha256.Options{});
        sha256State.update(asBytes(&self));
        var digest: [32]u8 = undefined;
        sha256State.final(&digest);
        return digest;
    }
};
pub const Chain = struct {
    chain: std.ArrayList(Block),
    pub fn init(self: *Chain) !void {
        try self.chain.append(Block{
            .previous_hash = null,
            .transaction = Transaction{
                .amount = 100,
                .payer = 0,
                .payee = 1,
            },
            .timestamp = std.time.nanoTimestamp(),
        });
    }
    pub fn add(self: *Chain, transaction: Transaction) !void {
        try self.chain.append(Block{
            .previous_hash = self.getLastBlock().hash(),
            .transaction = transaction,
            .timestamp = std.time.nanoTimestamp(),
        });
    }
    pub fn getLastBlock(self: Chain) Block {
        return self.chain.getLast();
    }
};
pub const Wallet = struct {
    public_key: Ed25519.PublicKey = undefined,
    secret_key: Ed25519.SecretKey = undefined,
    pub fn init(self: *Wallet) !void {
        const keys = try Ed25519.KeyPair.create(null);
        self.public_key = keys.public_key;
        self.secret_key = keys.secret_key;
    }
};
