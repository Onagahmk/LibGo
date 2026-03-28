import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/book.dart';

class GoogleBooksService {
  final String _apiKey = "AIzaSyCsXeNWU6hW_nzm71U6UPJECslp3nL-bLo";

  Future<List<Book>> searchBooks(String query) async {
    final url = Uri.parse(
        'https://www.googleapis.com/books/v1/volumes?q=$query&key=$_apiKey');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> items = data['items'] ?? [];

        return items.map((item) {
          final volumeInfo = item['volumeInfo'];
          return Book(
            title: volumeInfo['title'] ?? 'No Title',
            author: (volumeInfo['authors'] as List<dynamic>?)?.join(', ') ?? 'Unknown Author',
            synopsis: volumeInfo['description'] ?? 'No description available.',
            coverUrl: volumeInfo['imageLinks']?['thumbnail'] ?? '',
            filePath: '',
          );
        }).toList();
      } else {
        throw Exception('Failed to load books from API');
      }
    } catch (e) {
      return [];
    }
  }
}
