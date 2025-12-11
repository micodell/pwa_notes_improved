import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pwa_notes_improved/pages/edit_note_page.dart';
import '../providers/notes_provider.dart';
// import '../providers/theme_provider.dart';
import '../pages/add_note_page.dart';
import '../pages/settings_page.dart';
import '../widgets/note_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<void> _initialFetch() async {
    // fetch latest from API (UI will show cached if offline inside provider)
    await context.read<NotesProvider>().fetchFromApi();
  }

  @override
  void initState() {
    super.initState();
    // run after build to allow context.read in init
    WidgetsBinding.instance.addPostFrameCallback((_) => _initialFetch());
  }

  Future<void> _onRefresh() async {
    await context.read<NotesProvider>().fetchFromApi();
  }

  @override
  Widget build(BuildContext context) {
    final notesProv = context.watch<NotesProvider>();
    final notes = notesProv.notes;

    return Scaffold(
      appBar: AppBar(
        title: const Text('PWA Notes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsPage()),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              const DrawerHeader(
                child: Text('Menu', style: TextStyle(fontSize: 20)),
              ),
              ListTile(
                leading: const Icon(Icons.note),
                title: const Text('All notes'),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.refresh),
                title: const Text('Fetch from API'),
                onTap: () {
                  Navigator.pop(context);
                  context.read<NotesProvider>().fetchFromApi();
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete_forever),
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
        onRefresh: _onRefresh,
        child: Builder(
          builder: (context) {
            if (notesProv.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (notesProv.error != null && notes.isEmpty) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  const SizedBox(height: 80),
                  Center(
                    child: Text(
                      'Error: ${'' /* show in separate widget below */}',
                    ),
                  ),
                ],
              );
            }
            if (notes.isEmpty) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 80),
                  Center(
                    child: Text('Belum ada catatan. Tekan + untuk menambah.'),
                  ),
                ],
              );
            }
            return ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                return NoteCard(
                  note: note,
                  onDelete: () {
                    context.read<NotesProvider>().removeNoteAt(index);
                  },
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditNotePage(index: index, note: note),
                      ),
                    );
                    // showModalBottomSheet(
                    //   context: context,
                    //   builder: (_) => Padding(
                    //     padding: const EdgeInsets.all(16),
                    //     child: Column(
                    //       mainAxisSize: MainAxisSize.min,
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: [
                    //         Text(note.title, style: Theme.of(context).textTheme.titleLarge),
                    //         const SizedBox(height: 8),
                    //         Text(note.body ?? 'No body', style: Theme.of(context).textTheme.bodyMedium),
                    //         const SizedBox(height: 8),
                    //         Text('Created: ${note.createdAt.toLocal()}'),
                    //       ],
                    //     ),
                    //   ),
                    // );
                  },
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // go to add page
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddNotePage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
