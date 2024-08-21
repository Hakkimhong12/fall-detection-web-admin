import 'package:fall_detection_web_admin/upload/addinfo.dart';
import 'package:flutter/material.dart';
  // Import the migration function

class MigrationPage extends StatelessWidget {
  const MigrationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Data Migration'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await migrateDataToFirebase();  // Call the migration function
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Data migration completed!')),
            );
          },
          child: const Text('Migrate Data to Firebase'),
        ),
      ),
    );
  }
}
