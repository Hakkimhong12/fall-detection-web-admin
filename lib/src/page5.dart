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
  final TextEditingController _videoUrlController = TextEditingController();
  final TextEditingController _roomController = TextEditingController();
  final TextEditingController _cameraIdController = TextEditingController();

  // Variables to store selected dropdown values
  String? _selectedTime;
  String? _selectedHour;

  bool _isLoading = false;

  @override
  void dispose() {
    _videoUrlController.dispose();
    _cameraIdController.dispose();
    _roomController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('Camera Informations')
            .where('cameraId', isEqualTo: _cameraIdController.text)
            .get();

        final QuerySnapshot roomQuerySnapshot = await FirebaseFirestore.instance
            .collection('Camera Informations')
            .where('room', isEqualTo: _roomController.text)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('このカメラIDは既に登録されています。')),
          );
        } else if (roomQuerySnapshot.docs.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('この部屋は既に登録されています。')),
          );
        } else {
          await FirebaseFirestore.instance
              .collection('Camera Informations')
              .add({
            'cameraId': _cameraIdController.text,
            'cameraUrl': _videoUrlController.text,
            'fallDetectionRecordTime': _selectedTime,
            'cameraRecordTime': _selectedHour,
            'room': _roomController.text,
            'timestamp': FieldValue.serverTimestamp(),
          });

          _formKey.currentState?.reset();
          _cameraIdController.clear();
          _videoUrlController.clear();
          _roomController.clear();
          setState(() {
            _selectedTime = null;
            _selectedHour = null;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('登録が完了しました')),
          );
        }
      } catch (e) {
        print('Error submitting from');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('エラーが発生しました。もう一度お試しください。')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Methods to get dropdown items
  List<DropdownMenuItem<String>> _getTimeDropdownItems() {
    List<DropdownMenuItem<String>> items = [];
    final Map<String, int> options = {
      '5s': 5,
      '10s': 10,
      '30s': 30,
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
      '1mn': 60,
      '1hour': 1 * 3600,
      '3hour': 3 * 3600,
      '6hour': 6 * 3600,
      '12hour': 12 * 3600,
      '24hours': 24 * 3600,
    };
    options.forEach((key, value) {
      items.add(DropdownMenuItem(
        value: key,
        child: Text(key),
      ));
    });
    return items;
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
              const SizedBox(height: 30),
              _buildSidebarButton('カメラの全画面表示', '/page2'),
              const SizedBox(height: 30),
              _buildSidebarButton('アラートメール確認者登録', '/page4'),
              const SizedBox(height: 30),
              _buildSidebarButton('既存ユーザーの患者登録', '/registrationExistingUser'),
              const SizedBox(height: 30.0),
              const Text('カメラ登録',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18)),
              const SizedBox(height: 30),
              _buildSidebarButton('ユーザーアカウント削除', '/deleteUserAccount'),
              const SizedBox(height: 30),
              _buildSidebarButton('初期設定', '/page6'),
              const SizedBox(height: 30),
              _buildSidebarButton('Fall History', '/notification'),
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
                _buildTextField('カメラID', _cameraIdController, 'カメラIDを入力してください'),
                const SizedBox(height: 16),
                _buildTextField('部屋', _roomController, '部屋番号を入力してください'),
                const SizedBox(height: 16),
                _buildTextField('動画を表示するURL', _videoUrlController,
                    'http://www.gcp.com/.......',
                    keyboardType: TextInputType.url),
                const SizedBox(height: 16),

                // Add Dropdowns here
                _buildDropdownField(
                  '転倒検知録画時間',
                  _selectedTime,
                  _getTimeDropdownItems(),
                  (String? newValue) {
                    setState(() {
                      _selectedTime = newValue;
                    });
                  },
                ),
                const SizedBox(height: 16),
                _buildDropdownField(
                  '録画時間設定',
                  _selectedHour,
                  _getHourDropdownItems(),
                  (String? newValue) {
                    setState(() {
                      _selectedHour = newValue;
                    });
                  },
                ),
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

  // Reusable Dropdown Field
  Widget _buildDropdownField(String label, String? selectedValue,
      List<DropdownMenuItem<String>> items, ValueChanged<String?> onChanged) {
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
          child: DropdownButtonFormField<String>(
            value: selectedValue,
            decoration: const InputDecoration(
              border: InputBorder.none,
            ),
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
            setState(() {
              _selectedTime = null;
              _selectedHour = null;
            });
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
          _buildSidebar(context),
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
