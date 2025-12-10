class Note {
  final int? id; // optional for local-only notes
  final String title;
  final String? body;
  final DateTime createdAt;

  Note({
    this.id,
    required this.title,
    this.body,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'] is int ? json['id'] : int.tryParse('${json['id']}'),
      title: json['title'] ?? '',
      body: json['body'] ?? json['body'] ?? null,
      createdAt: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
      'id': id,
      'title': title,
      'body': body,
      'createdAt': createdAt.toIso8601String(),
    };
}
