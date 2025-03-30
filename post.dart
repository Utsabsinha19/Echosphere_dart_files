class Post {
  final String id;
  final String content;
  final String author;
  final DateTime timestamp;
  final List<String> tags;
  final String? emotion;
  final bool isAR;
  final String? arAssetUrl;

  Post({
    required this.id,
    required this.content,
    required this.author,
    required this.timestamp,
    this.tags = const [],
    this.emotion,
    this.isAR = false,
    this.arAssetUrl,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      content: json['content'],
      author: json['author'],
      timestamp: DateTime.parse(json['timestamp']),
      tags: List<String>.from(json['tags'] ?? []),
      emotion: json['emotion'],
      isAR: json['isAR'] ?? false,
      arAssetUrl: json['arAssetUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'author': author,
      'timestamp': timestamp.toIso8601String(),
      'tags': tags,
      'emotion': emotion,
      'isAR': isAR,
      'arAssetUrl': arAssetUrl,
    };
  }
}
