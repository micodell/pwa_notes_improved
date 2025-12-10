import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/note.dart';

class NotesProvider extends ChangeNotifier {
  List<Note> _notes = [];
  bool _loading = false;
  String? _error;

  List<Note> get notes => _notes;
  bool get loading => _loading;
  String? get error => _error;

  // Local-only add (from AddNote page)
  void addNote(Note note) {
    _notes.insert(0, note); // newest first
    notifyListeners();
  }

  void removeNoteAt(int index) {
    _notes.removeAt(index);
    notifyListeners();
  }

  // Fetch sample notes from JSONPlaceholder (title -> Note.title)
  Future<void> fetchNotesFromApi() async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      final uri = Uri.parse('https://jsonplaceholder.typicode.com/posts?_limit=20');
      final res = await http.get(uri);
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body) as List<dynamic>;
        _notes = data.map((e) => Note.fromJson(e as Map<String, dynamic>)).toList();
      } else {
        _error = 'Server responded ${res.statusCode}';
      }
    } catch (e) {
      _error = e.toString();
      if (kDebugMode) print('fetch error: $e');
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  // Clear notes (for demo)
  void clear() {
    _notes = [];
    notifyListeners();
  }
}
