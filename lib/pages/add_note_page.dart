import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/note.dart';
import '../providers/notes_provider.dart';

class AddNotePage extends StatefulWidget {
  const AddNotePage({super.key});
  @override
  State<AddNotePage> createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  final TextEditingController _titleC = TextEditingController();
  final TextEditingController _bodyC = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _titleC.dispose();
    _bodyC.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final title = _titleC.text.trim();
    final body = _bodyC.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Title cannot be empty')));
      return;
    }
    setState(() => _saving = true);
    final note = Note(title: title, body: body.isEmpty ? null : body);
    context.read<NotesProvider>().addNote(note);
    await Future.delayed(const Duration(milliseconds: 150));
    setState(() => _saving = false);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Catatan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleC,
              decoration: const InputDecoration(labelText: 'Judul'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _bodyC,
              decoration: const InputDecoration(labelText: 'Isi (opsional)'),
              maxLines: 5,
            ),
            const SizedBox(height: 20),
            _saving
                ? const CircularProgressIndicator()
                : ElevatedButton.icon(
                    onPressed: _save,
                    icon: const Icon(Icons.save),
                    label: const Text('Simpan'),
                  ),
          ],
        ),
      ),
    );
  }
}
