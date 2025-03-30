class Post {
  final String id;
  final String content;
  final String author;
  final DateTime timestamp;
  final String? summary;
  final String emotionType;
  final int emotionScore;
  final bool isAR;
  final String? imageUrl;
  final String? arContentUrl;

  Post({
    required this.id,
    required this.content,
    required this.author,
    required this.timestamp,
    this.summary,
    this.emotionType = 'neutral',
    this.emotionScore = 50,
    this.isAR = false,
    this.imageUrl,
    this.arContentUrl,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      content: json['content'],
      author: json['author'],
      timestamp: DateTime.parse(json['timestamp']),
      summary: json['summary'],
      emotionType: json['emotionType'] ?? 'neutral',
      emotionScore: json['emotionScore'] ?? 50,
      isAR: json['isAR'] ?? false,
      imageUrl: json['imageUrl'],
      arContentUrl: json['arContentUrl'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'content': content,
    'author': author,
    'timestamp': timestamp.toIso8601String(),
    'summary': summary,
    'emotionType': emotionType,
    'emotionScore': emotionScore,
    'isAR': isAR,
    'imageUrl': imageUrl,
    'arContentUrl': arContentUrl,
  };
}
