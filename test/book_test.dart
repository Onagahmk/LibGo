import 'package:flutter_test/flutter_test.dart';
import 'package:libgo/models/book.dart';

void main() {
  group('Book Model Tests', () {
    test('should convert from map correctly', () {
      final map = {
        'id': 1,
        'title': 'Test Book',
        'author': 'Author Name',
        'synopsis': 'Synopsis here',
        'coverUrl': 'http://image.com',
        'filePath': '/path/to/file',
      };

      final book = Book.fromMap(map);

      expect(book.id, 1);
      expect(book.title, 'Test Book');
      expect(book.author, 'Author Name');
    });

    test('should convert to map correctly', () {
      final book = Book(
        id: 1,
        title: 'Test Book',
        author: 'Author Name',
        synopsis: 'Synopsis here',
        coverUrl: 'http://image.com',
        filePath: '/path/to/file',
      );

      final map = book.toMap();

      expect(map['id'], 1);
      expect(map['title'], 'Test Book');
      expect(map['author'], 'Author Name');
    });

    test('copyWith should return a new object with updated values', () {
      final book = Book(
        title: 'Original',
        author: 'Original',
        synopsis: '',
        coverUrl: '',
        filePath: '',
      );

      final updated = book.copyWith(title: 'Updated');

      expect(updated.title, 'Updated');
      expect(updated.author, 'Original');
    });
  });
}
