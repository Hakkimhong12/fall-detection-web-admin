import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Registrationexistinguser extends StatefulWidget {
  const Registrationexistinguser({super.key});

  @override
  State<Registrationexistinguser> createState() =>
      _RegistrationexistinguserState();
}

class _RegistrationexistinguserState extends State<Registrationexistinguser> {
  bool isTextPressed = false;
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  Uint8List? _selectedImage;
  String? _imageUrl;
  String? _fileName;
  int _imagePickerKey = 0;

  List<String> _rooms = [];
  String? _selectedRoom;
  bool _isLoadingRooms = false;

  List<Map<String, dynamic>> _users = [];
  String? _selectedUserId;

  final _formKey = GlobalKey<FormState>();
  String? _selectedRelationship;
  String? _selectedCategory;
  final TextEditingController _cameraIdController = TextEditingController();
  final TextEditingController _targetNameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchRooms();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('User Informations')
          .get();
      setState(() {
        _users = snapshot.docs
            .map((doc) => {
                  'id': doc.id,
                  'name': doc['userName'] as String,
                })
            .toList();
      });
    } catch (e) {
      print('Error fetching users');
    }
  }

  Future<void> _fetchRooms() async {
    setState(() {
      _isLoadingRooms = true;
    });
    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('Camera Informations')
          .get();
      setState(() {
        _rooms =
            snapshot.docs.map((doc) => doc['room'] as String).toSet().toList();
        _isLoadingRooms = false;
      });
    } catch (e) {
      print("Error fetching rooms: $e");
      setState(() {
        _isLoadingRooms = false;
      });
    }
  }

  Future<void> _updateCameraId(String room) async {
    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('Camera Informations')
          .where('room', isEqualTo: room)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final doc = snapshot.docs.first.data() as Map<String, dynamic>;
        setState(() {
          _cameraIdController.text = doc['cameraId'] as String? ?? '';
        });
      } else {
        setState(() {
          _cameraIdController.clear();
        });
      }
    } catch (e) {
      print("Error fetching camera ID: $e");
      setState(() {
        _cameraIdController.clear();
      });
    }
  }

  void _pickImage() {
    html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
    uploadInput.accept = 'Patient Image Folder/*'; // Accept only image files
    uploadInput.click(); // Open the file picker

    uploadInput.onChange.listen((event) {
      final files = uploadInput.files;
      if (files!.isNotEmpty) {
        final reader = html.FileReader();

        reader.readAsArrayBuffer(files[0]); // Read the file as an array buffer
        reader.onLoadEnd.listen((e) {
          setState(() {
            _selectedImage = reader.result as Uint8List?;
            _fileName = files[0].name; // Store the file name
          });
        });
      }
    });
  }

  Future<void> _uploadImage() async {
    if (_selectedImage == null) return;
    final storageRef = FirebaseStorage.instance.ref().child(
        'Patient Image Folder/${DateTime.now().microsecondsSinceEpoch}_$_fileName');
    final uploadTask = storageRef.putData(_selectedImage!);
    final snapshot = await uploadTask.whenComplete(() => {});
    final downloadUrl = await snapshot.ref.getDownloadURL();

    setState(() {
      _imageUrl = downloadUrl; // Store the image URL
      _selectedImage = null;
      _fileName = null;
    });
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
                      color: Colors.grey,
                      width: 2.0,
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
                    const SizedBox(height: 30),
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
                    const SizedBox(height: 30.0),
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
                    const SizedBox(height: 30),
                    const Text('既存ユーザーの患者登録',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18)),
                    const SizedBox(height: 30),
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
                    const SizedBox(height: 30),
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
                        Navigator.pushNamed(context, '/deleteUserAccount');
                      },
                      onTapCancel: () {
                        setState(() {
                          isTextPressed = false;
                        });
                      },
                      child: Text(
                        'ユーザーアカウント削除',
                        style: TextStyle(
                            color: isTextPressed ? Colors.black : Colors.white,
                            fontWeight: FontWeight.normal,
                            fontSize: 18,
                            decoration: TextDecoration.none),
                      ),
                    ),
                    const SizedBox(height: 30),
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
                        Navigator.pushNamed(context, '/page6');
                      },
                      onTapCancel: () {
                        setState(() {
                          isTextPressed = false;
                        });
                      },
                      child: Text(
                        '初期設定',
                        style: TextStyle(
                            color: isTextPressed ? Colors.black : Colors.white,
                            fontWeight: FontWeight.normal,
                            fontSize: 18,
                            decoration: TextDecoration.none),
                      ),
                    ),
                    const SizedBox(height: 30),
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
                        'Fall History',
                        style: TextStyle(
                            color: isTextPressed ? Colors.black : Colors.white,
                            fontWeight: FontWeight.normal,
                            fontSize: 18,
                            decoration: TextDecoration.none),
                      ),
                    ),
                    //const Spacer(),
                    const SizedBox(height: 150),
                    const Padding(
                      padding: EdgeInsets.only(left: 110),
                      child: Text(
                        'ケアヴュー1.2',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          decoration: TextDecoration.none,
                        ),
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
                            color: const Color(0xFFD9C1AE),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text('既存ユーザーの患者登録',
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
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                const SizedBox(height: 16),
                                _buildUserDropdown(),
                                const SizedBox(height: 16),
                                _buildTextField('対象者氏名', _targetNameController,
                                    '山田はな', false, TextInputType.text),
                                const SizedBox(height: 16),
                                _buildDropdownField('続柄', _selectedRelationship,
                                    ['息子', '娘', '父親', '母親', 'その他'], (newValue) {
                                  setState(() {
                                    _selectedRelationship = newValue;
                                  });
                                }),
                                const SizedBox(height: 16),
                                _buildDropdownField(
                                    '担当区分', _selectedCategory, ['家族', 'その他'],
                                    (newValue) {
                                  setState(() {
                                    _selectedCategory = newValue;
                                  });
                                }),
                                const SizedBox(height: 16),
                                _buildDropdownField('場所', _selectedRoom, _rooms,
                                    (newValue) {
                                  setState(() {
                                    _selectedRoom = newValue;
                                    _locationController.text = newValue ?? '';
                                    _updateCameraId(newValue!);
                                  });
                                }),
                                _buildTextField('カメラID', _cameraIdController,
                                    'AZ101', false, TextInputType.text,
                                    readOnly: true),
                                const SizedBox(height: 16),
                                _buildImagePicker(),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 25, horizontal: 40),
                                        foregroundColor: Colors.black,
                                        backgroundColor: const Color(
                                            0xFFD9C1AE), // background color
                                        // text color
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
                                        backgroundColor: const Color(
                                            0xFFD9C1AE), // background color
                                        // text color
                                      ),
                                      onPressed: _isLoading
                                          ? null
                                          : _handleRegistration,
                                      child: const Text('登録'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Text Field Widget
  Widget _buildTextField(String label, TextEditingController controller,
      String hintText, bool isPassword, TextInputType inputType,
      {bool readOnly = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          child: TextFormField(
            controller: controller,
            obscureText: isPassword ? !_isPasswordVisible : false,
            keyboardType: inputType,
            readOnly: readOnly,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hintText,
              suffixIcon: isPassword
                  ? IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    )
                  : null,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '$labelを入力してください';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildImagePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('画像をアップロード',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Row(
          children: [
            ElevatedButton(
              key: ValueKey(_imagePickerKey), // Unique key to force rebuild
              onPressed: _pickImage,
              child: const Text('画像を選択'),
            ),
            const SizedBox(width: 16),
            _selectedImage != null
                ? Column(
                    children: [
                      Text('File selected: $_fileName'),
                      const SizedBox(height: 10),
                      Image.memory(
                        _selectedImage!,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ],
                  )
                : const Text('画像が選択されていません'),
          ],
        ),
      ],
    );
  }

  // Reusable Dropdown Widget
  Widget _buildDropdownField(String label, String? selectedValue,
      List<String> options, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          child: DropdownButtonFormField<String>(
            value: selectedValue,
            decoration: const InputDecoration(
              border: InputBorder.none,
            ),
            items: options.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
  Widget _buildUserDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'ユーザー',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          child: DropdownButtonFormField<String>(
            value: _selectedUserId,
            decoration: const InputDecoration(
              border: InputBorder.none,
            ),
            items: _users.map((user) {
              return DropdownMenuItem<String>(
                value: user['id'],
                child: Text(user['name']),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedUserId = newValue;
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'ユーザーを選択してください';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Future<void> _handleRegistration() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final cameraId = _cameraIdController.text;
        final userUid = _selectedUserId; // This is already the userUid

        // Check if the cameraId already exists
        final QuerySnapshot cameraSnapshot = await FirebaseFirestore.instance
            .collection('Patient Informations')
            .where('cameraId', isEqualTo: cameraId)
            .get();

        if (cameraSnapshot.docs.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Camera ID already exists!')),
          );
          setState(() {
            _isLoading = false;
          });
          return;
        }

        // Upload image if one is selected
        if (_selectedImage != null) {
          await _uploadImage();
        }

        // Create a new Camera Access document
        Map<String, dynamic> cameraAccessData = {
          'cameraId': cameraId,
          'userUid': userUid,
        };
        await FirebaseFirestore.instance
            .collection('Camera Access')
            .add(cameraAccessData);

        // Create a new Patient Information document
        Map<String, dynamic> patientData = {
          'imageUrl_patient': _imageUrl,
          'cameraId': cameraId,
          'patientName': _targetNameController.text,
          'room': _locationController.text,
          'timestamp': FieldValue.serverTimestamp(),
        };
        DocumentReference patientDocRef = await FirebaseFirestore.instance
            .collection('Patient Informations')
            .add(patientData);

        // Create a new Patient Family document
        Map<String, dynamic> patientFamilyData = {
          'category': _selectedCategory,
          'patientDocumentId': patientDocRef.id,
          'userUid': userUid,
          'relationship': _selectedRelationship,
        };
        await FirebaseFirestore.instance
            .collection('Patient Family')
            .add(patientFamilyData);

        // Clear the fields after successful registration
        _clearFields();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('登録が完了しました')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('エラーが発生しました。もう一度お試しください。: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _clearFields() {
    _cameraIdController.clear();
    _targetNameController.clear();
    _locationController.clear();
    setState(() {
      _selectedUserId = null;
      _selectedRelationship = null;
      _selectedCategory = null;
      _selectedImage = null;
      _imageUrl = null;
      _fileName = null;
      _imagePickerKey++;
    });
  }

}
