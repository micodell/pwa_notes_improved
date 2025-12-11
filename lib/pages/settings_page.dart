import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/notes_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});
  @override
  Widget build(BuildContext context) {
    final themeProv = context.watch<ThemeProvider>();
    final notesProv = context.watch<NotesProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Dark mode'),
            value: themeProv.isDark,
            onChanged: (v) => context.read<ThemeProvider>().setDark(v),
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('Jumlah catatan'),
            subtitle: Text('${notesProv.notes.length}'),
          ),
          ListTile(
            leading: const Icon(Icons.refresh),
            title: const Text('Fetch dari API'),
            onTap: () => context.read<NotesProvider>().fetchFromApi(),
          ),
          ListTile(
            leading: const Icon(Icons.delete),
            title: const Text('Hapus semua catatan (local)'),
            onTap: () {
              context.read<NotesProvider>().clear();
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Catatan dihapus')));
            },
          ),
        ],
      ),
    );
  }
}
