import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:libgo/viewmodels/book_viewmodel.dart';
import 'package:libgo/models/book.dart';
import 'package:libgo/data/database_helper.dart';
import 'package:libgo/services/google_books_service.dart';
import 'package:libgo/di/service_locator.dart';

class MockDatabaseHelper extends Mock implements DatabaseHelper {}
class MockGoogleBooksService extends Mock implements GoogleBooksService {}

void main() {
  late BookViewModel viewModel;
  late MockDatabaseHelper mockDb;
  late MockGoogleBooksService mockApi;

  setUpAll(() {
    mockDb = MockDatabaseHelper();
    mockApi = MockGoogleBooksService();
    
    // Register mocks in GetIt
    getIt.registerSingleton<DatabaseHelper>(mockDb);
    getIt.registerSingleton<GoogleBooksService>(mockApi);
  });

  setUp(() {
    viewModel = BookViewModel();
  });

  group('BookViewModel Tests', () {
    test('initial state should be empty', () {
      expect(viewModel.books, isEmpty);
      expect(viewModel.isLoading, false);
    });

    test('fetchBooks should update books list', () async {
      final books = [
        Book(title: 'B1', author: 'A1', synopsis: '', coverUrl: '', filePath: ''),
      ];
      when(() => mockDb.readAllBooks()).thenAnswer((_) async => books);

      await viewModel.fetchBooks();

      expect(viewModel.books.length, 1);
      expect(viewModel.books[0].title, 'B1');
    });

    test('searchApi should update searchResults', () async {
      final results = [
        Book(title: 'Result 1', author: 'Author', synopsis: '', coverUrl: '', filePath: ''),
      ];
      when(() => mockApi.searchBooks(any())).thenAnswer((_) async => results);

      await viewModel.searchApi('query');

      expect(viewModel.searchResults.length, 1);
      expect(viewModel.searchResults[0].title, 'Result 1');
    });

    test('sortBooks should sort by title correctly', () async {
      final books = [
        Book(title: 'B', author: 'Author', synopsis: '', coverUrl: '', filePath: ''),
        Book(title: 'A', author: 'Author', synopsis: '', coverUrl: '', filePath: ''),
      ];

      when(() => mockDb.readAllBooks()).thenAnswer((_) async => books);
      await viewModel.fetchBooks();

      viewModel.sortBooks('title_asc');
      expect(viewModel.books[0].title, 'A');

      viewModel.sortBooks('title_desc');
      expect(viewModel.books[0].title, 'B');
    });
  });
}
