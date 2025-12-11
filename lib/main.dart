import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pages/home_page.dart';
import 'providers/notes_provider.dart';
import 'providers/theme_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NotesProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProv = context.watch<ThemeProvider>();

    final light = ThemeData(
      brightness: Brightness.light,
      useMaterial3: true,
      primarySwatch: Colors.blue,
      textTheme: const TextTheme(
        titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        bodyMedium: TextStyle(fontSize: 14),
      ),
    );

    final dark = ThemeData(
      brightness: Brightness.dark,
      useMaterial3: true,
      primarySwatch: Colors.blue,
      textTheme: const TextTheme(
        titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        bodyMedium: TextStyle(fontSize: 14),
      ),
    );

    return MaterialApp(
      title: 'Notes PWA',
      debugShowCheckedModeBanner: false,
      theme: light,
      darkTheme: dark,
      themeMode: themeProv.themeMode,
      home: const HomePage(),
    );
  }
}
