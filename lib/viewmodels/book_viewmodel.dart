import 'package:flutter/material.dart';
import '../models/book.dart';
import '../data/database_helper.dart';
import '../services/google_books_service.dart';
import '../di/service_locator.dart';

class BookViewModel extends ChangeNotifier {
  final DatabaseHelper _dbHelper = getIt<DatabaseHelper>();
  final GoogleBooksService _apiService = getIt<GoogleBooksService>();

  List<Book> _books = [];
  List<Book> get books => _books;

  List<Book> _searchResults = [];
  List<Book> get searchResults => _searchResults;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  Future<void> fetchBooks() async {
    _isLoading = true;
    notifyListeners();
    _books = await _dbHelper.readAllBooks();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addBook(Book book) async {
    await _dbHelper.create(book);
    await fetchBooks();
  }

  Future<void> updateBook(Book book) async {
    await _dbHelper.update(book);
    await fetchBooks();
  }

  Future<void> deleteBook(int id) async {
    await _dbHelper.delete(id);
    await fetchBooks();
  }

  Future<void> searchApi(String query) async {
    _isLoading = true;
    notifyListeners();
    _searchResults = await _apiService.searchBooks(query);
    _isLoading = false;
    notifyListeners();
  }

  void setSearchResults(List<Book> results) {
    _searchResults = results;
    notifyListeners();
  }

  void sortBooks(String criteria) {
    if (criteria == 'title_asc') {
      _books.sort((a, b) => a.title.compareTo(b.title));
    } else if (criteria == 'title_desc') {
      _books.sort((a, b) => b.title.compareTo(a.title));
    } else if (criteria == 'author') {
      _books.sort((a, b) => a.author.compareTo(b.author));
    }
    notifyListeners();
  }

  void filterBooks(String query) {
    _searchQuery = query;
    if (query.isEmpty) {
      fetchBooks();
    } else {
      _books = _books.where((book) =>
          book.title.toLowerCase().contains(query.toLowerCase()) ||
          book.author.toLowerCase().contains(query.toLowerCase())).toList();
      notifyListeners();
    }
  }
}
