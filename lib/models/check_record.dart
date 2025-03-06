class CheckRecord {
  final String id;
  final String userId;
  final DateTime timestamp;
  final String type; // 'in' o 'out'

  CheckRecord({
    required this.id,
    required this.userId,
    required this.timestamp,
    required this.type,
  });

  factory CheckRecord.fromJson(Map<String, dynamic> json) {
    return CheckRecord(
      id: json['id'] as String,
      userId: json['userId'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      type: json['type'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'timestamp': timestamp.toIso8601String(),
      'type': type,
    };
  }
}
