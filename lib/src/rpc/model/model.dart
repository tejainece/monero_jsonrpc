DateTime fromTimestamp(int timestamp) =>
    DateTime.fromMillisecondsSinceEpoch(timestamp * 1000, isUtc: true);
