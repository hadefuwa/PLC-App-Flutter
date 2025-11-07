class MetricsSnapshot {
  final DateTime timestamp;
  final double throughput;
  final double fpy;
  final int rejectCount;
  final int totalCount;

  MetricsSnapshot({
    required this.timestamp,
    required this.throughput,
    required this.fpy,
    required this.rejectCount,
    required this.totalCount,
  });

  Map<String, dynamic> toJson() => {
    'timestamp': timestamp.toIso8601String(),
    'throughput': throughput,
    'fpy': fpy,
    'rejectCount': rejectCount,
    'totalCount': totalCount,
  };
}

class EventLogEntry {
  final DateTime timestamp;
  final String name;
  final String value;
  final String type; // 'input' or 'output'

  EventLogEntry({
    required this.timestamp,
    required this.name,
    required this.value,
    required this.type,
  });

  Map<String, dynamic> toJson() => {
    'timestamp': timestamp.toIso8601String(),
    'name': name,
    'value': value,
    'type': type,
  };
}

class BatchRecord {
  final String id;
  final String recipe;
  final int target;
  final DateTime startTime;
  final DateTime? endTime;
  final int produced;
  final int rejects;

  BatchRecord({
    required this.id,
    required this.recipe,
    required this.target,
    required this.startTime,
    this.endTime,
    this.produced = 0,
    this.rejects = 0,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'recipe': recipe,
    'target': target,
    'startTime': startTime.toIso8601String(),
    'endTime': endTime?.toIso8601String(),
    'produced': produced,
    'rejects': rejects,
  };
}
