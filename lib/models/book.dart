class Book {
  final int? id;
  final String title;
  final String author;
  final String synopsis;
  final String coverUrl;
  final String filePath;

  Book({
    this.id,
    required this.title,
    required this.author,
    required this.synopsis,
    required this.coverUrl,
    required this.filePath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'synopsis': synopsis,
      'coverUrl': coverUrl,
      'filePath': filePath,
    };
  }

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'],
      title: map['title'],
      author: map['author'],
      synopsis: map['synopsis'],
      coverUrl: map['coverUrl'],
      filePath: map['filePath'],
    );
  }

  Book copyWith({
    int? id,
    String? title,
    String? author,
    String? synopsis,
    String? coverUrl,
    String? filePath,
  }) {
    return Book(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      synopsis: synopsis ?? this.synopsis,
      coverUrl: coverUrl ?? this.coverUrl,
      filePath: filePath ?? this.filePath,
    );
  }
}
