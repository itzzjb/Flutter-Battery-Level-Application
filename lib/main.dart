import 'package:flutter/material.dart';
import 'package:maridian/pages/home.dart';

// Method Channels -->
// Used to communicate with the underlying Operationg System (Android, iOS) and get some information to call in flutter.
// Not everything can be shared across underlying OS and flutter
// It's very limited type of data can be trasfered / shared
// https://docs.flutter.dev/platform-integration/platform-channels

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

