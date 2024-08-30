import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Page5 extends StatefulWidget {
  const Page5({super.key});

  @override
  State<Page5> createState() => _Page5State();
}

class _Page5State extends State<Page5> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for form fields
  final TextEditingController _cameraIdController = TextEditingController();
  final TextEditingController _targetNameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _videoUrlController = TextEditingController();
  final TextEditingController _loginIdController = TextEditingController();
  final TextEditingController _loginPasswordController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    // Dispose controllers to prevent memory leaks
    _cameraIdController.dispose();
    _targetNameController.dispose();
    _locationController.dispose();
    _videoUrlController.dispose();
    _loginIdController.dispose();
    _loginPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Fetch imageUrl from user_acc based on cameraId
        final userDoc = await FirebaseFirestore.instance
            .collection('user_acc')
            .where('camera_id', isEqualTo: _cameraIdController.text)
            .get();

        String? imageUrl;

        if (userDoc.docs.isNotEmpty) {
          imageUrl = userDoc.docs.first.data()['imageUrl'] as String?;
        }

        // Add data to cameraDetails collection
        await FirebaseFirestore.instance.collection('cameraDetails').add({
          'cameraId': _cameraIdController.text,
          'targetName': _targetNameController.text,
          'location': _locationController.text,
          'videoUrl': _videoUrlController.text,
          'loginId': _loginIdController.text,
          'loginPassword': _loginPasswordController.text,
          'imageUrl': imageUrl, // Include the fetched imageUrl
          'timestamp': FieldValue.serverTimestamp(),
        });

        // Clear form and reset state
        _formKey.currentState?.reset();
        _cameraIdController.clear();
        _targetNameController.clear();
        _locationController.clear();
        _videoUrlController.clear();
        _loginIdController.clear();
        _loginPasswordController.clear();

        setState(() {
          _isLoading = false;
        });

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('登録が完了しました')),
        );
      } catch (e) {
        // Handle any errors
        print('Error submitting form: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('エラーが発生しました。もう一度お試しください。')),
        );
      } finally {
        // Ensure loading state is reset even if an error occurs
        setState(() {
          _isLoading = false;
        });
      }
    }
  }


  // Sidebar Widget
  Widget _buildSidebar(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: constraints.maxWidth > 600 ? 250 : 200,
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
              _buildSidebarButton('AIカメラ管理画面', '/page1'),
              const SizedBox(height: 100),
              _buildSidebarButton('カメラの全画面表示', '/page2'),
              const SizedBox(height: 70),
              _buildSidebarButton('アラートメール確認者登録', '/page4'),
              const SizedBox(height: 50.0),
              const Text('カメラ登録',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18)),
              const SizedBox(height: 50),
              _buildSidebarButton('初期設定', '/page6'),
              const SizedBox(height: 50),
              _buildSidebarButton('通知', '/notification'),
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
        );
      },
    );
  }

  // Sidebar Button Widget
  Widget _buildSidebarButton(String title, String route) {
    return GestureDetector(
      onTapDown: (_) => setState(() {}),
      onTapUp: (_) {
        setState(() {});
        Navigator.pushNamed(context, route);
      },
      onTapCancel: () => setState(() {}),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.normal,
          decoration: TextDecoration.none,
        ),
      ),
    );
  }

  // Form Fields
  Widget _buildFormFields() {
    return Form(
      key: _formKey,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildTextField('カメラID', _cameraIdController, 'AZ201'),
                const SizedBox(height: 16),
                _buildTextField('対象者氏名', _targetNameController, '山田はな'),
                const SizedBox(height: 16),
                _buildTextField(
                    '動画を表示するURL', _videoUrlController, 'http://www.gcp.com/.......',
                    keyboardType: TextInputType.url),
                const SizedBox(height: 16),
                _buildTextField('ログインID', _loginIdController, 'AZ20I'),
                const SizedBox(height: 16),
                _buildTextField('ログインパスワード', _loginPasswordController, '*****',
                    obscureText: true),
                const SizedBox(height: 16),
                _buildTextField('場所', _locationController, '102号室'),
                const SizedBox(height: 16),
                _buildFormButtons(),
              ],
            ),
          );
        },
      ),
    );
  }

  // Reusable Text Field
  Widget _buildTextField(
      String label, TextEditingController controller, String hintText,
      {bool obscureText = false,
      TextInputType keyboardType = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
            obscureText: obscureText,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hintText,
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

  // Form Buttons
  Widget _buildFormButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 40),
            foregroundColor: Colors.black,
            backgroundColor: const Color(0xFFD9C1AE),
          ),
          onPressed: () {
            _formKey.currentState?.reset();
            setState(() {});
          },
          child: const Text('戻る'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 40),
            foregroundColor: Colors.black,
            backgroundColor: const Color(0xFFD9C1AE),
          ),
          onPressed: _submitForm,
          child: const Text('登録'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          _buildSidebar(context), // Pass the context here
          Expanded(
            child: Stack(
              children: [
                Column(
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
                          child: const Text('カメラ登録',
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
                        child: _buildFormFields(),
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
          ),
        ],
      ),
    );
  }
}
