const std = @import("std");
const print = std.debug.print;
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
    nonce: u64 = undefined,
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
    pub fn mine(self: *Block, valid_zeros: u8) void {
        print("(T) mining...\t", .{});
        self.nonce = 0;
        var valid = false;

        while (!valid) {
            self.nonce += 1;
            const hashed_block = self.hash();
            var zero_correct = true;
            for (0..valid_zeros) |i| {
                if (hashed_block[i] != 0) {
                    zero_correct = false;
                }
            }
            if (zero_correct) {
                valid = true;
            }
        }
        print("Answer: {d}\n\n", .{ self.nonce });
        print("Hash Bytes: {any}\n\n", .{ self.hash() });
    }
};
pub const Chain = struct {
    chain: std.ArrayList(Block) = undefined,
    valid_zeros: u8,
    pub fn init(self: *Chain) !void {
        const keys = try Ed25519.KeyPair.create(null);
        try self.chain.append(Block{
            .previous_hash = null,
            .transaction = Transaction{
                .amount = 0,
                .payer = keys.public_key,
                .payee = keys.public_key,
            },
            .timestamp = std.time.nanoTimestamp(),
        });
    }
    pub fn add(self: *Chain, transaction: Transaction, senders_public_key: Ed25519.PublicKey, signature: Ed25519.Signature) !void {
        try signature.verify(asBytes(&transaction), senders_public_key);
        var new_block = Block{
            .previous_hash = self.getLastBlock().hash(),
            .transaction = transaction,
            .timestamp = std.time.nanoTimestamp(),
        };
        new_block.mine(self.valid_zeros);
        const hashed_block = new_block.hash();
        var zero_correct = true;
        for (0..self.valid_zeros) |i| {
            if (hashed_block[i] != 0) {
                zero_correct = false;
            }
        }
        if (!zero_correct) {
            print("BLOCK NOT VALID", .{});
            return;
        }
        try self.chain.append(new_block);
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
        // print("Trying to send {d}bucks from {any} to {any}\n\n", .{ amount, self.key_pair.public_key, payee_public_key });
        const wallet_amount = self.getMoney(chain.*);
        if (amount > wallet_amount) {
            print("NOT ENOUGH FUNDS", .{});
            return;
        }
        const transaction = Transaction{
            .amount = amount,
            .payer = self.key_pair.public_key,
            .payee = payee_public_key,
        };
        const signature = try self.key_pair.sign(asBytes(&transaction), null); // this is a deterministic signiture
        try chain.add(transaction, self.key_pair.public_key, signature);
    }
    pub fn getMoney(self: Wallet, chain: Chain) u64 {
        var wallet_amount: u64 = 1000; // starting out with 1000 bucks each
        for (chain.chain.items) |block| {
            const transaction = block.transaction;
            if (std.mem.eql(u8, &transaction.payee.toBytes(), &self.key_pair.public_key.toBytes())) {
                wallet_amount += transaction.amount;
            }
            if (std.mem.eql(u8, &transaction.payer.toBytes(), &self.key_pair.public_key.toBytes())) {
                wallet_amount -= transaction.amount;
            }
        }
        return wallet_amount;
    }
};
