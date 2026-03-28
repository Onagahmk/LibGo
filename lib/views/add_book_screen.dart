import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import '../viewmodels/book_viewmodel.dart';
import '../models/book.dart';

class AddBookScreen extends StatefulWidget {
  const AddBookScreen({super.key});

  @override
  State<AddBookScreen> createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _author = '';
  String _synopsis = '';
  String _coverUrl = '';
  String _filePath = '';
  final TextEditingController _searchController = TextEditingController();

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'docx', 'doc', 'rtf', 'txt'],
    );

    if (result != null) {
      setState(() {
        _filePath = result.files.single.path!;
      });
    }
  }

  void _onApiBookSelected(Book book) {
    setState(() {
      _title = book.title;
      _author = book.author;
      _synopsis = book.synopsis;
      _coverUrl = book.coverUrl;
    });
    Navigator.pop(context); // Close the search dialog/bottom sheet
  }

  void _showSearchDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Pesquisar na Google Books',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    context.read<BookViewModel>().searchApi(_searchController.text);
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Consumer<BookViewModel>(
                builder: (context, viewModel, child) {
                  if (viewModel.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return ListView.builder(
                    itemCount: viewModel.searchResults.length,
                    itemBuilder: (context, index) {
                      final book = viewModel.searchResults[index];
                      return ListTile(
                        leading: book.coverUrl.isNotEmpty ? Image.network(book.coverUrl, width: 50) : const Icon(Icons.book),
                        title: Text(book.title),
                        subtitle: Text(book.author),
                        onTap: () => _onApiBookSelected(book),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Adicionar Livro')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton.icon(
                onPressed: _pickFile,
                icon: const Icon(Icons.attach_file),
                label: Text(_filePath.isEmpty ? 'Selecionar Arquivo (PDF, Docx...)' : 'Arquivo: ${_filePath.split('/').last}'),
              ),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: _showSearchDialog,
                icon: const Icon(Icons.travel_explore),
                label: const Text('Buscar dados na API'),
              ),
              const Divider(height: 30),
              TextFormField(
                key: Key('titleField_$_title'),
                initialValue: _title,
                decoration: const InputDecoration(labelText: 'Título'),
                onChanged: (v) => _title = v,
                validator: (v) => v!.isEmpty ? 'Campo obrigatório' : null,
              ),
              TextFormField(
                key: Key('authorField_$_author'),
                initialValue: _author,
                decoration: const InputDecoration(labelText: 'Autor'),
                onChanged: (v) => _author = v,
                validator: (v) => v!.isEmpty ? 'Campo obrigatório' : null,
              ),
              TextFormField(
                key: Key('synopsisField_$_synopsis'),
                initialValue: _synopsis,
                decoration: const InputDecoration(labelText: 'Sinopse'),
                maxLines: 3,
                onChanged: (v) => _synopsis = v,
              ),
              TextFormField(
                key: Key('coverUrlField_$_coverUrl'),
                initialValue: _coverUrl,
                decoration: const InputDecoration(labelText: 'URL da Capa'),
                onChanged: (v) => _coverUrl = v,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancelar'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final book = Book(
                          title: _title,
                          author: _author,
                          synopsis: _synopsis,
                          coverUrl: _coverUrl,
                          filePath: _filePath,
                        );
                        context.read<BookViewModel>().addBook(book);
                        Navigator.pop(context);
                      }
                    },
                    child: const Text('Salvar'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
