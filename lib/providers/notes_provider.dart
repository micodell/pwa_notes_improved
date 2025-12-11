import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../models/note.dart';

class NotesProvider extends ChangeNotifier {
  List<Note> _notes = [];
  bool _loading = false;
  String? _error;

  List<Note> get notes => _notes;
  bool get loading => _loading;
  String? get error => _error;

  static const String _cacheKey = 'cached_notes_json';

  NotesProvider() {
    // Saat provider dibuat, coba load cached data dulu lalu fetch terbaru
    _loadCachedData();
    // We won't auto-fetch here: caller (HomePage) akan memanggil fetchFromApi di initState
  }

  Future<void> _loadCachedData() async {
    final prefs = await SharedPreferences.getInstance();
    final cached = prefs.getString(_cacheKey);
    if (cached != null && cached.isNotEmpty) {
      try {
        final decoded = jsonDecode(cached) as List<dynamic>;
        _notes = decoded
            .map((e) => Note.fromJson(e as Map<String, dynamic>))
            .toList();
        notifyListeners();
      } catch (_) {
        // ignore parse errors
      }
    }
  }

  void addNote(Note note) {
    _notes.insert(0, note);
    notifyListeners();
  }

  void updateNote(int index, Note updatedNote) {
    if (index >= 0 && index < _notes.length) {
      _notes[index] = updatedNote;
      notifyListeners();
    }
  }

  void removeNoteAt(int index) {
    if (index >= 0 && index < _notes.length) {
      _notes.removeAt(index);
      notifyListeners();
    }
  }

  void clear() {
    _notes = [];
    notifyListeners();
  }

  Future<void> fetchFromApi() async {
    _loading = true;
    _error = null;
    notifyListeners();
    final uri = Uri.parse(
      'https://jsonplaceholder.typicode.com/posts?_limit=10',
    );
    try {
      final res = await http.get(uri).timeout(const Duration(seconds: 10));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body) as List<dynamic>;
        _notes = data.map((e) {
          final map = e as Map<String, dynamic>;
          return Note.fromJson({
            'id': map['id'],
            'title': map['title'],
            'body': map['body'],
          });
        }).toList();
        // cache the raw list (we store as list of maps)
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(
          _cacheKey,
          jsonEncode(_notes.map((n) => n.toJson()).toList()),
        );
      } else {
        _error = 'Server responded ${res.statusCode}';
        // try load cached
        await _loadCachedData();
      }
    } catch (e) {
      // network error -> load cached data
      _error = 'Fetch failed: $e';
      await _loadCachedData();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
