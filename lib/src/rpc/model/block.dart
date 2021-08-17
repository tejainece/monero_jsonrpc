class BlockHeader {
  /// The block size in bytes.
  final int blockSize;

  /// The number of blocks succeeding this block on the blockchain. A larger number means an older block.
  final int depth;

  /// The strength of the Monero network based on mining power.
  final int difficulty;

  /// The hash of this block.
  final String hash;

  /// The number of blocks preceding this block on the blockchain.
  final int height;

  /// The major version of the monero protocol at this block height.
  final int majorVersion;

  /// The minor version of the monero protocol at this block height.
  final int minorVersion;

  /// a cryptographic random one-time number used in mining a Monero block.
  final int nonce;

  /// Number of transactions in the block, not counting the coinbase tx.
  final int numTxes;

  /// Usually false. If true, this block is not part of the longest chain.
  final bool orphanStatus;

  /// The hash of the block immediately preceding this block in the chain.
  final String prevHash;

  /// The amount of new atomic units generated in this block and rewarded to the
  /// miner. Note: 1 XMR = 1e12 atomic units.
  final int reward;

  /// The unix time at which the block was recorded into the blockchain.
  final DateTime timestamp;

  BlockHeader(
      {required this.blockSize,
      required this.depth,
      required this.difficulty,
      required this.hash,
      required this.height,
      required this.majorVersion,
      required this.minorVersion,
      required this.nonce,
      required this.numTxes,
      required this.orphanStatus,
      required this.prevHash,
      required this.reward,
      required this.timestamp});

  Map<String, dynamic> toJson() => {
        'block_size': blockSize,
        'depth': depth,
        'difficulty': difficulty,
        'hash': hash,
        'height': height,
        'major_version': majorVersion,
        'minor_version': minorVersion,
        'nonce': nonce,
        'num_txes': numTxes,
        'orphan_status': orphanStatus,
        'prev_hash': prevHash,
        'reward': reward,
        'timestamp': timestamp.toUtc().millisecondsSinceEpoch ~/ 1000,
      };

  static BlockHeader fromMap(Map map) => BlockHeader(
        blockSize: map['block_size'],
        depth: map['depth'],
        difficulty: map['difficulty'],
        hash: map['hash'],
        height: map['height'],
        majorVersion: map['major_version'],
        minorVersion: map['minor_version'],
        nonce: map['nonce'],
        numTxes: map['num_txes'],
        orphanStatus: map['orphan_status'],
        prevHash: map['prev_hash'],
        reward: map['reward'],
        timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp'] * 1000,
            isUtc: true),
      );
}

class Block {
  /// Hexadecimal blob of block information.
  final String blob;

  /// A structure containing block header information.
  final BlockHeader blockHeader;
  /*
json - json string; JSON formatted block details:
major_version - Same as in block header.
minor_version - Same as in block header.
timestamp - Same as in block header.
prev_id - Same as prev_hash in block header.
nonce - Same as in block header.
miner_tx - Miner transaction information
version - Transaction version number.
unlock_time - The block height when the coinbase transaction becomes spendable.
vin - List of transaction inputs:
gen - Miner txs are coinbase txs, or "gen".
height - This block height, a.k.a. when the coinbase is generated.
vout - List of transaction outputs. Each output contains:
amount - The amount of the output, in atomic units.
target -
key -
extra - Usually called the "transaction ID" but can be used to include any random 32 byte/64 character hex string.
signatures - Contain signatures of tx signers. Coinbased txs do not have signatures.
tx_hashes - List of hashes of non-coinbase transactions in the block. If there are no other transactions, this will be an empty list.
status - string; General RPC error code. "OK" means everything looks good.
untrusted - boolean; States if the result is obtained using the bootstrap mode, and is therefore not trusted (true), or when the daemon is fully synced (false).
   */
  Block({required this.blob, required this.blockHeader});

  Map<String, dynamic> toJson() => {
        'blob': blob,
        'block_header': blockHeader,
      };

  static Block fromMap(Map map) {
    return Block(
      blob: map['blob'],
      blockHeader: BlockHeader.fromMap(map['block_header']),
    );
  }
}
