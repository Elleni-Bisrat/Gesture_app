class MessageModel {
  final String id;
  final String text;
  final String sender;
  final DateTime timestamp;
  final String type;
  final bool isTranslated;
  final String? translation;

  MessageModel({
    required this.id,
    required this.text,
    required this.sender,
    required this.timestamp,
    required this.type,
    this.isTranslated = false,
    this.translation,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'sender': sender,
      'timestamp': timestamp,
      'type': type,
      'isTranslated': isTranslated,
      'translation': translation,
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      id: map['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      text: map['text'] ?? '',
      sender: map['sender'] ?? 'unknown',
      timestamp: map['timestamp'] != null 
          ? map['timestamp'].toDate() 
          : DateTime.now(),
      type: map['type'] ?? 'text',
      isTranslated: map['isTranslated'] ?? false,
      translation: map['translation'],
    );
  }

  MessageModel copyWith({
    String? id,
    String? text,
    String? sender,
    DateTime? timestamp,
    String? type,
    bool? isTranslated,
    String? translation,
  }) {
    return MessageModel(
      id: id ?? this.id,
      text: text ?? this.text,
      sender: sender ?? this.sender,
      timestamp: timestamp ?? this.timestamp,
      type: type ?? this.type,
      isTranslated: isTranslated ?? this.isTranslated,
      translation: translation ?? this.translation,
    );
  }
}