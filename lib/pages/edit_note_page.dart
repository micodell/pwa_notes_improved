import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/note.dart';
import '../providers/notes_provider.dart';

class EditNotePage extends StatefulWidget {
  final int index;
  final Note note;

  const EditNotePage({super.key, required this.index, required this.note});

  @override
  State<EditNotePage> createState() => _EditNotePageState();
}

class _EditNotePageState extends State<EditNotePage> {
  late TextEditingController _titleC;
  late TextEditingController _bodyC;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _titleC = TextEditingController(text: widget.note.title);
    _bodyC = TextEditingController(text: widget.note.body ?? '');
  }

  @override
  void dispose() {
    _titleC.dispose();
    _bodyC.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_titleC.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Title cannot be empty")));
      return;
    }

    setState(() => _saving = true);

    final updated = Note(
      id: widget.note.id,
      title: _titleC.text.trim(),
      body: _bodyC.text.trim(),
      createdAt: widget.note.createdAt, // keep original timestamp
    );

    context.read<NotesProvider>().updateNote(widget.index, updated);

    await Future.delayed(const Duration(milliseconds: 150));

    setState(() => _saving = false);

    Navigator.pop(context);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Note")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleC,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _bodyC,
              decoration: const InputDecoration(labelText: 'Body'),
              maxLines: 5,
            ),
            const SizedBox(height: 20),
            _saving
                ? const CircularProgressIndicator()
                : ElevatedButton.icon(
                    onPressed: _save,
                    label: const Text("Save Changes"),
                    icon: const Icon(Icons.save),
                  ),
          ],
        ),
      ),
    );
  }
}
