class DataStreamLogEntry {
  final DateTime timestamp;
  final String direction; // 'TX' (transmit) or 'RX' (receive)
  final String address;
  final String value;
  final String? description;

  DataStreamLogEntry({
    required this.timestamp,
    required this.direction,
    required this.address,
    required this.value,
    this.description,
  });

  Map<String, dynamic> toJson() => {
    'timestamp': timestamp.toIso8601String(),
    'direction': direction,
    'address': address,
    'value': value,
    'description': description,
  };

  factory DataStreamLogEntry.fromJson(Map<String, dynamic> json) {
    return DataStreamLogEntry(
      timestamp: DateTime.parse(json['timestamp']),
      direction: json['direction'],
      address: json['address'],
      value: json['value'],
      description: json['description'],
    );
  }
}

