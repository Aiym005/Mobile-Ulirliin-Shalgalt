class Comment {
  final String name;
  final String text;
  final String userId;
  final int timestamp;
  final String productId;

  Comment({
    required this.name,
    required this.text,
    required this.userId,
    required this.timestamp,
    required this.productId,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'text': text,
      'userId': userId,
      'timestamp': timestamp,
      'productId': productId,
    };
  }

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      name: json['name'] ?? 'Unknown',
      text: json['text'] ?? '',
      userId: json['userId'] ?? '',
      timestamp: json['timestamp'] ?? 0,
      productId: json['productId'] ?? '',
    );
  }
}
