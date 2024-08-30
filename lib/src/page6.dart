import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fall_detection_web_admin/api/camera_setting_api.dart';
import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert'; // for utf8.encode

class Page6 extends StatefulWidget {
  const Page6({super.key});

  @override
  State<Page6> createState() => _Page6State();
}

class _Page6State extends State<Page6> {
  bool isTextPressed = false;
  bool _isLoading = false; // Track loading state
  final _formKey = GlobalKey<FormState>();
  final CameraSettingAPI _cameraSettingAPI = CameraSettingAPI();

  final TextEditingController _cameraIdController = TextEditingController();

  String? _selectedCameraId;
  String? _fallDetectionRecordTime;
  String? _cameraRecordTime;

  List<String> _cameraIds = [];

  @override
  void initState() {
    super.initState();
    _fetchCameraIds();
  }

  @override
  void dispose() {
    _cameraIdController.dispose();
    super.dispose();
  }

  Future<void> _fetchCameraIds() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('cameraDetails').get();
      List<String> ids =
          snapshot.docs.map((doc) => doc['cameraId'] as String).toList();
      setState(() {
        _cameraIds = ids;
      });
    } catch (e) {
      print('Error fetching camera IDS: $e');
    }
  }

  List<DropdownMenuItem<String>> _getTimeDropdownItems() {
    List<DropdownMenuItem<String>> items = [];
    final Map<String, int> options = {
      '5s': 5,
      '10s': 10,
      '15minutes': 15 * 60,
      '30minutes': 30 * 60,
    };
    options.forEach((key, value) {
      items.add(DropdownMenuItem(
        value: key,
        child: Text(key),
      ));
    });
    return items;
  }

  List<DropdownMenuItem<String>> _getHourDropdownItems() {
    List<DropdownMenuItem<String>> items = [];
    final Map<String, int> options = {
      '1hour': 1 * 3600,
      '3hour': 3 * 3600,
      '6hour': 6 * 3600,
      '12hour': 12 * 3600,
      '24hours': 24 * 3600,
      '1week': 7 * 24 * 3600,
      '1month': 30 * 24 * 3600,
      '3month': 90 * 24 * 3600,
      '6months': 180 * 24 * 3600,
    };
    options.forEach((key, value) {
      items.add(DropdownMenuItem(
        value: key,
        child: Text(key),
      ));
    });
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width > 800 ? 250 : 200,
                padding: const EdgeInsets.all(5.0),
                decoration: const BoxDecoration(
                  color: Color(0xFFA67B5B),
                  border: Border(
                    right: BorderSide(
                      color: Colors.grey, // Color of the gray line
                      width: 2.0, // Width of the gray line
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 50.0),
                    GestureDetector(
                      onTapDown: (_) {
                        setState(() {
                          isTextPressed = true;
                        });
                      },
                      onTapUp: (_) {
                        setState(() {
                          isTextPressed = false;
                        });
                        Navigator.pushNamed(context, '/page1');
                      },
                      onTapCancel: () {
                        setState(() {
                          isTextPressed = false;
                        });
                      },
                      child: Text(
                        'AIカメラ管理画面',
                        style: TextStyle(
                            color: isTextPressed ? Colors.black : Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.normal,
                            decoration: TextDecoration.none),
                      ),
                    ),
                    const SizedBox(height: 100),
                    GestureDetector(
                      onTapDown: (_) {
                        setState(() {
                          isTextPressed = true;
                        });
                      },
                      onTapUp: (_) {
                        setState(() {
                          isTextPressed = false;
                        });
                        Navigator.pushNamed(context, '/page2');
                      },
                      onTapCancel: () {
                        setState(() {
                          isTextPressed = false;
                        });
                      },
                      child: Text(
                        'カメラの全画面表示',
                        style: TextStyle(
                            color: isTextPressed ? Colors.black : Colors.white,
                            fontWeight: FontWeight.normal,
                            fontSize: 18,
                            decoration: TextDecoration.none),
                      ),
                    ),
                    const SizedBox(height: 70),
                    GestureDetector(
                      onTapDown: (_) {
                        setState(() {
                          isTextPressed = true;
                        });
                      },
                      onTapUp: (_) {
                        setState(() {
                          isTextPressed = false;
                        });
                        Navigator.pushNamed(context, '/page4');
                      },
                      onTapCancel: () {
                        setState(() {
                          isTextPressed = false;
                        });
                      },
                      child: Text(
                        'アラートメール確認者登録',
                        style: TextStyle(
                            color: isTextPressed ? Colors.black : Colors.white,
                            fontWeight: FontWeight.normal,
                            fontSize: 18,
                            decoration: TextDecoration.none),
                      ),
                    ),
                    const SizedBox(height: 50),
                    GestureDetector(
                      onTapDown: (_) {
                        setState(() {
                          isTextPressed = true;
                        });
                      },
                      onTapUp: (_) {
                        setState(() {
                          isTextPressed = false;
                        });
                        Navigator.pushNamed(context, '/page5');
                      },
                      onTapCancel: () {
                        setState(() {
                          isTextPressed = false;
                        });
                      },
                      child: Text(
                        'カメラ登録',
                        style: TextStyle(
                            color: isTextPressed ? Colors.black : Colors.white,
                            fontWeight: FontWeight.normal,
                            fontSize: 18,
                            decoration: TextDecoration.none),
                      ),
                    ),
                    const SizedBox(height: 50.0),
                    const Text('初期設定',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18)),
                    const SizedBox(height: 50),
                    GestureDetector(
                      onTapDown: (_) {
                        setState(() {
                          isTextPressed = true;
                        });
                      },
                      onTapUp: (_) {
                        setState(() {
                          isTextPressed = false;
                        });
                        Navigator.pushNamed(context, '/notification');
                      },
                      onTapCancel: () {
                        setState(() {
                          isTextPressed = false;
                        });
                      },
                      child: Text(
                        '通知',
                        style: TextStyle(
                            color: isTextPressed ? Colors.black : Colors.white,
                            fontWeight: FontWeight.normal,
                            fontSize: 18,
                            decoration: TextDecoration.none),
                      ),
                    ),
                    const SizedBox(height: 150),
                    const Padding(
                      padding: EdgeInsets.only(left: 110),
                      child: Text(
                        'ケアヴュー1.2',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            decoration: TextDecoration.none),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    // Header
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 20),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD2B48C),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text('初期設定',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.normal)),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 30.0,
                            horizontal: MediaQuery.of(context).size.width > 1000
                                ? 350.0
                                : 20.0,
                          ),
                          child: Form(
                            key: _formKey,
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  const SizedBox(height: 16),
                                  _buildDropdownRow(
                                      'カメラID',
                                      _selectedCameraId,
                                      _cameraIds.map((id) => DropdownMenuItem(
                                          value: id, child: Text(id))).toList(),
                                      (String? newValue) {
                                    setState(() {
                                      _selectedCameraId = newValue;
                                    });
                                  }),
                                  const SizedBox(height: 16),
                                  _buildDropdownRow('転倒検知録画時間', _fallDetectionRecordTime,
                                      _getTimeDropdownItems(),
                                      (String? newValue) {
                                    setState(() {
                                      _fallDetectionRecordTime = newValue;
                                    });
                                  }),
                                  const SizedBox(height: 16),
                                  _buildDropdownRow('録画時間設定', _cameraRecordTime,
                                      _getHourDropdownItems(),
                                      (String? newValue) {
                                    setState(() {
                                      _cameraRecordTime = newValue;
                                    });
                                  }),
                                  const SizedBox(height: 30),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 25, horizontal: 40),
                                          foregroundColor: Colors.black,
                                          backgroundColor:
                                              const Color(0xFFD9C1AE),
                                        ),
                                        onPressed: () {
                                          // Handle back button press
                                        },
                                        child: const Text('戻る'),
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 25, horizontal: 40),
                                          foregroundColor: Colors.black,
                                          backgroundColor:
                                              const Color(0xFFD9C1AE),
                                        ),
                                        onPressed: _isLoading
                                            ? null
                                            : _submitCameraSettings,
                                        child: const Text('登録'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }

  void _submitCameraSettings() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true; // Show loading indicator
      });

      try {
        // Query the Firestore to get the document ID based on the selected cameraId
        final snapshot = await FirebaseFirestore.instance
            .collection('cameraDetails')
            .where('cameraId', isEqualTo: _selectedCameraId)
            .get();

        if (snapshot.docs.isNotEmpty) {
          // Get the document ID
          String docId = snapshot.docs.first.id;

          // Update the document in Firestore
          await FirebaseFirestore.instance
              .collection('cameraDetails')
              .doc(docId)
              .update({
            'fallDetectionRecordTime': _fallDetectionRecordTime,
            'cameraRecordTime': _cameraRecordTime,
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Settings updated successfully!')),
          );
        } else {
          // Handle the case where no document is found
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Camera ID not found. Please check and try again.')),
          );
        }
      } catch (error) {
        print('Error updating document: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Failed to update settings. Please try again.')),
        );
      } finally {
        setState(() {
          _isLoading = false; // Hide loading indicator
        });
      }
    }
  }

  Widget _buildDropdownRow(String label, String? selectedValue,
      List<DropdownMenuItem<String>> items, ValueChanged<String?> onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          flex: 3,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                border: InputBorder.none,
              ),
              value: selectedValue,
              items: items,
              onChanged: onChanged,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '$labelを選択してください';
                }
                return null;
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextFieldRow(String label, String hintText,
      TextInputType inputType, TextEditingController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          flex: 3,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: TextFormField(
              controller: controller,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hintText,
              ),
              keyboardType: inputType,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '$labelを入力してください';
                }
                return null;
              },
            ),
          ),
        ),
      ],
    );
  }
}
