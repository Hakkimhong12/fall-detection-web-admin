import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:typed_data';

Future<void> migrateDataToFirebase() async {
  final List<String> imagePaths = [
    'assets/images/image1.jpg',
    'assets/images/image2.jpg',
    'assets/images/image3.jpg',
    'assets/images/image4.jpg',
    'assets/images/img5.jpg',
    'assets/images/img6.jpg',
  ];

  final List<Map<String, String>> cameraData = [
    {
      'cameraId': 'A0121',
      'targetName': '前川さつ',
      'location': '部屋番号 202',
    },
    {
      'cameraId': 'A0122',
      'targetName': '福田隆',
      'location': '部屋番号 204',
    },
    {
      'cameraId': 'A0123',
      'targetName': '平林美智子',
      'location': '部屋番号 206',
    },
    {
      'cameraId': 'A0124',
      'targetName': '山田はな',
      'location': '部屋番号 208',
    },
    {
      'cameraId': 'A0125',
      'targetName': '高橋健',
      'location': '部屋番号 210',
    },
    {
      'cameraId': 'A0125',
      'targetName': '高橋健',
      'location': '部屋番号 210',
    },
    // Add more entries as needed
  ];

  for (int i = 0; i < imagePaths.length; i++) {
    String imagePath = imagePaths[i];
    
    try {
      // Load image as bytes
      ByteData byteData = await rootBundle.load(imagePath);
      Uint8List imageBytes = byteData.buffer.asUint8List();
      
      // Generate a unique file name
      String fileName = 'images/${DateTime.now().millisecondsSinceEpoch}.jpg';
      
      // Upload image to Firebase Cloud Storage
      final storageRef = FirebaseStorage.instance.ref().child(fileName);
      UploadTask uploadTask = storageRef.putData(imageBytes);
      TaskSnapshot snapshot = await uploadTask.whenComplete(() => null);

      String downloadURL = await snapshot.ref.getDownloadURL();

      // Store metadata in Firestore
      await FirebaseFirestore.instance.collection('cameraDetails').add({
        'cameraId': cameraData[i]['cameraId'],
        'targetName': cameraData[i]['targetName'],
        'location': cameraData[i]['location'],
        'imageUrl': downloadURL,
      });
    } catch (e) {
      print('Error uploading image or storing data: $e');
    }
  }
}
