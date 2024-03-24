const std = @import("std");
const crypto = std.crypto;
const Sha256 = crypto.hash.sha2.Sha256;
const Ed25519 = crypto.sign.Ed25519;
const asBytes = std.mem.asBytes;

pub const Transaction = struct {
    amount: u64,
    payer: Ed25519.PublicKey,
    payee: Ed25519.PublicKey,
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
    chain: std.ArrayList(Block) = undefined,
    pub fn init(self: *Chain) !void {
        const keys = try Ed25519.KeyPair.create(null);
        try self.chain.append(Block{
            .previous_hash = null,
            .transaction = Transaction{
                .amount = 100,
                .payer = keys.public_key,
                .payee = keys.public_key,
            },
            .timestamp = std.time.nanoTimestamp(),
        });
    }
    pub fn add(self: *Chain, transaction: Transaction, senders_public_key: Ed25519.PublicKey, signature: Ed25519.Signature) !void {
        try signature.verify(asBytes(&transaction), senders_public_key);
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
    key_pair: Ed25519.KeyPair = undefined,
    pub fn init(self: *Wallet) !void {
        self.key_pair = try Ed25519.KeyPair.create(null);
    }
    pub fn sendMoney(self: Wallet, chain: *Chain, amount: u64, payee_public_key: Ed25519.PublicKey) !void {
        const transaction = Transaction{
            .amount = amount,
            .payer = self.key_pair.public_key,
            .payee = payee_public_key,
        };
        const signature = try self.key_pair.sign(asBytes(&transaction), null); // this is a deterministic signiture
        try chain.add(transaction, self.key_pair.public_key, signature);
    }
};
