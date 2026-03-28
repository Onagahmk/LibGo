import 'package:get_it/get_it.dart';
import '../data/database_helper.dart';
import '../services/google_books_service.dart';

final getIt = GetIt.instance;

void setupLocator() {
  getIt.registerLazySingleton(() => DatabaseHelper.instance);
  getIt.registerLazySingleton(() => GoogleBooksService());
}
