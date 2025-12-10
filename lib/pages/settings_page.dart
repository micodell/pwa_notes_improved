import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/notes_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProv = context.watch<ThemeProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          SwitchListTile(
            value: themeProv.isDark,
            title: const Text('Dark mode'),
            onChanged: (v) => context.read<ThemeProvider>().setDark(v),
          ),
          ListTile(
            leading: const Icon(Icons.refresh),
            title: const Text('Fetch notes from API'),
            onTap: () => context.read<NotesProvider>().fetchNotesFromApi(),
          ),
          ListTile(
            leading: const Icon(Icons.delete),
            title: const Text('Clear notes'),
            onTap: () => context.read<NotesProvider>().clear(),
          )
        ],
      ),
    );
  }
}
