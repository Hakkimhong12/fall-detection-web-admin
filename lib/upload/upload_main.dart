import 'package:fall_detection_web_admin/firebase_options.dart';
import 'package:fall_detection_web_admin/upload/migration.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
 // Import your migration page

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);  // Initialize Firebase
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Migration',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MigrationPage(),  // Set the migration page as the home screen
    );
  }
}