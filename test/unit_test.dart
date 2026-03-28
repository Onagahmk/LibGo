import 'package:flutter_test/flutter_test.dart';
import 'package:libgo/models/book.dart';
import 'package:libgo/viewmodels/book_viewmodel.dart';
import 'package:libgo/di/service_locator.dart';
import 'package:libgo/data/database_helper.dart';
import 'package:libgo/services/google_books_service.dart';
import 'package:mocktail/mocktail.dart';


class MockDatabaseHelper extends Mock implements DatabaseHelper {}
class MockGoogleBooksService extends Mock implements GoogleBooksService {}

void main() {
  late BookViewModel viewModel;
  late MockDatabaseHelper mockDb;
  late MockGoogleBooksService mockApi;

  setUpAll(() {
    mockDb = MockDatabaseHelper();
    mockApi = MockGoogleBooksService();
    

    getIt.registerSingleton<DatabaseHelper>(mockDb);
    getIt.registerSingleton<GoogleBooksService>(mockApi);
  });

  setUp(() {
    viewModel = BookViewModel();

    when(() => mockDb.readAllBooks()).thenAnswer((_) async => []);
  });

  group('LibGo Unit Tests', () {
    

    test('1. Deve criar um objeto Book e converter para Map corretamente', () {
      final book = Book(
        id: 1,
        title: 'Clean Code',
        author: 'Robert C. Martin',
        synopsis: 'A handbook of agile software craftsmanship',
        coverUrl: 'http://image.com',
        filePath: '/path/pdf',
      );

      final map = book.toMap();

      expect(map['title'], 'Clean Code');
      expect(map['author'], 'Robert C. Martin');
      expect(book.title, 'Clean Code');
    });


    test('2. Deve ordenar a lista de livros por título (A-Z)', () async {
      final bookA = Book(title: 'A Book', author: 'Z Author', synopsis: '', coverUrl: '', filePath: '');
      final bookB = Book(title: 'B Book', author: 'A Author', synopsis: '', coverUrl: '', filePath: '');
      


      when(() => mockDb.readAllBooks()).thenAnswer((_) async => [bookB, bookA]);

      await viewModel.fetchBooks();
      viewModel.sortBooks('title_asc');

      expect(viewModel.books.first.title, 'A Book');
    });


    test('3. Deve ordenar a lista de livros por autor', () async {
      final book1 = Book(title: 'Title 1', author: 'Z Author', synopsis: '', coverUrl: '', filePath: '');
      final book2 = Book(title: 'Title 2', author: 'A Author', synopsis: '', coverUrl: '', filePath: '');

      when(() => mockDb.readAllBooks()).thenAnswer((_) async => [book1, book2]);

      await viewModel.fetchBooks();
      viewModel.sortBooks('author');

      expect(viewModel.books.first.author, 'A Author');
    });


    test('4. Deve filtrar a lista de livros com base na pesquisa', () async {
      final book1 = Book(title: 'Flutter Guide', author: 'Dev', synopsis: '', coverUrl: '', filePath: '');
      final book2 = Book(title: 'Dart Basics', author: 'Dev', synopsis: '', coverUrl: '', filePath: '');

      when(() => mockDb.readAllBooks()).thenAnswer((_) async => [book1, book2]);

      await viewModel.fetchBooks();
      viewModel.filterBooks('Flutter');

      expect(viewModel.books.length, 1);
      expect(viewModel.books.first.title, 'Flutter Guide');
    });


    test('5. Deve alterar o estado de isLoading durante a busca', () async {
      when(() => mockDb.readAllBooks()).thenAnswer((_) async {
        await Future.delayed(const Duration(milliseconds: 100));
        return [];
      });

      final future = viewModel.fetchBooks();
      expect(viewModel.isLoading, true);
      
      await future;
      expect(viewModel.isLoading, false);
    });

  });
}
