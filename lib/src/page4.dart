import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Page4 extends StatefulWidget {
  const Page4({super.key});

  @override
  State<Page4> createState() => _Page4State();
}

class _Page4State extends State<Page4> {
  bool isTextPressed = false;
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();
  String? _selectedRelationship;
  String? _selectedCategory;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _cameraIdController = TextEditingController();
  final TextEditingController _targetNameController = TextEditingController();

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
                    const SizedBox(height: 70.0),
                    const Text('アラートメール確認者登録',
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
                        Navigator.pushNamed(context, '/page5');
                      },
                      onTapCancel: () {
                        setState(() {
                          isTextPressed = false;
                        });
                      },
                      child: Text(
                        'アラートメール情報',
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
                          child: const Text('アラートメール確認者登録',
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
                                _buildTextField(
                                    'メールアドレス',
                                    _emailController,
                                    'example@gmail.com',
                                    false,
                                    TextInputType.emailAddress),
                                const SizedBox(height: 16),
                                _buildTextField(
                                    'パスワード',
                                    _passwordController,
                                    '********',
                                    true,
                                    TextInputType.text),
                                const SizedBox(height: 16),
                                _buildTextField(
                                    '電話番号',
                                    _phoneController,
                                    '03-1122-3344',
                                    false,
                                    TextInputType.phone),
                                const SizedBox(height: 16),
                                _buildTextField(
                                    '氏名',
                                    _nameController,
                                    '山田 太郎',
                                    false,
                                    TextInputType.text),
                                const SizedBox(height: 16),
                                _buildDropdownField(
                                    '続柄',
                                    _selectedRelationship,
                                    ['息子', '娘', '父親', '母親', 'その他'],
                                    (newValue) {
                                      setState(() {
                                        _selectedRelationship = newValue;
                                      });
                                    }),
                                const SizedBox(height: 16),
                                _buildDropdownField(
                                    '担当区分',
                                    _selectedCategory,
                                    ['家族', 'その他'],
                                    (newValue) {
                                      setState(() {
                                        _selectedCategory = newValue;
                                      });
                                    }),
                                const SizedBox(height: 16),
                                _buildTextField(
                                    'カメラID',
                                    _cameraIdController,
                                    'AZ101',
                                    false,
                                    TextInputType.text),
                                const SizedBox(height: 16),
                                _buildTextField(
                                    '対象者氏名',
                                    _targetNameController,
                                    '山田はな',
                                    false,
                                    TextInputType.text),
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
                                          : () async {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                setState(() {
                                                  _isLoading = true;
                                                });
                                                // Process data
                                                final email =
                                                    _emailController.text;
                                                final password =
                                                    _passwordController.text;
                                                final phoneNumber =
                                                    _phoneController.text;
                                                final name =
                                                    _nameController.text;
                                                final relationship =
                                                    _selectedRelationship;
                                                final category =
                                                    _selectedCategory;
                                                final cameraId =
                                                    _cameraIdController.text;
                                                final targetName =
                                                    _targetNameController.text;

                                                try {
                                                  // Create a new user in Firebase Authentication
                                                  UserCredential
                                                      userCredential =
                                                      await FirebaseAuth
                                                          .instance
                                                          .createUserWithEmailAndPassword(
                                                              email: email,
                                                              password:
                                                                  password);

                                                  // Create a map for the user data
                                                  Map<String, dynamic>
                                                      userData = {
                                                    'uid': userCredential
                                                        .user?.uid,
                                                    'email': email,
                                                    'phone_number':
                                                        phoneNumber,
                                                    'name': name,
                                                    'relationship':
                                                        relationship,
                                                    'category': category,
                                                    'camera_id': cameraId,
                                                    'target_name': targetName,
                                                  };

                                                  // Save the data to Firestore
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection('user_acc')
                                                      .add(userData);

                                                  // Clear the fields after successful registration
                                                  _emailController.clear();
                                                  _passwordController.clear();
                                                  _phoneController.clear();
                                                  _nameController.clear();
                                                  _cameraIdController.clear();
                                                  _targetNameController.clear();

                                                  // Reset the dropdowns
                                                  setState(() {
                                                    _selectedRelationship =
                                                        null;
                                                    _selectedCategory = null;
                                                    _isLoading = false;
                                                  });

                                                  // Show a success message
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                        content: Text(
                                                            'User Registered Successfully!'),),
                                                  );
                                                } catch (e) {
                                                  setState(() {
                                                    _isLoading = false;
                                                  });
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                        content: Text(
                                                            'Failed to register user: $e')),
                                                  );
                                                }
                                              }
                                            },
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

  // Reusable Text Field Widget
  Widget _buildTextField(String label, TextEditingController controller,
      String hintText, bool isPassword, TextInputType inputType) {
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
}
