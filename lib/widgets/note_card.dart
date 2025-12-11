import 'package:flutter/material.dart';
import '../models/note.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  final VoidCallback? onDelete;
  final VoidCallback? onTap;

  const NoteCard({super.key, required this.note, this.onDelete, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        title: Text(note.title, style: Theme.of(context).textTheme.titleLarge),
        subtitle: note.body != null ? Text(note.body!, style: Theme.of(context).textTheme.bodyMedium) : null,
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline),
          onPressed: onDelete,
        ),
        onTap: onTap,
      ),
    );
  }
}
