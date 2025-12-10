import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/notes_provider.dart';
import '../models/note.dart';
import 'add_note_page.dart';
import 'settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Fetch when widget is first built
  @override
  void initState() {
    super.initState();
    // fetch notes after first frame to avoid context issues
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotesProvider>().fetchNotesFromApi();
    });
  }

  Future<void> _refresh() async {
    await context.read<NotesProvider>().fetchNotesFromApi();
  }

  @override
  Widget build(BuildContext context) {
    final notesProv = context.watch<NotesProvider>();
    final notes = notesProv.notes;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes PWA (Flutter)'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsPage()),
            ),
          )
        ],
      ),
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              const DrawerHeader(child: Text('Menu', style: TextStyle(fontSize: 20))),
              ListTile(
                leading: const Icon(Icons.note),
                title: const Text('All notes'),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text('Clear notes'),
                onTap: () {
                  context.read<NotesProvider>().clear();
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: notesProv.loading
            ? const Center(child: CircularProgressIndicator())
            : notesProv.error != null
                ? ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      Center(child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Text('Error: ${notesProv.error}'),
                      )),
                    ],
                  )
                : notes.isEmpty
                    ? ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: const [
                          SizedBox(height: 80),
                          Center(child: Text('No notes yet. Tap + to add.')),
                        ],
                      )
                    : ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: notes.length,
                        itemBuilder: (context, index) {
                          final Note note = notes[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                            child: Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              child: ListTile(
                                title: Text(note.title),
                                subtitle: note.body != null ? Text(note.body!) : null,
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete_outline),
                                  onPressed: () => context.read<NotesProvider>().removeNoteAt(index),
                                ),
                                onTap: () {
                                  // simple detail bottom sheet
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (_) => Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(note.title, style: Theme.of(context).textTheme.titleLarge),
                                          const SizedBox(height: 8),
                                          Text(note.body ?? 'No body'),
                                          const SizedBox(height: 8),
                                          Text('Created: ${note.createdAt}'),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final result = await Navigator.push(context, MaterialPageRoute(builder: (_) => const AddNotePage()));
          // result is a Note and will be added by AddNotePage using provider as well,
          // but if returned, you could handle it here.
        },
      ),
    );
  }
}
