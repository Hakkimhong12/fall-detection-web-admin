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
  final TextEditingController _patientNameController = TextEditingController();
  final TextEditingController _patientRoomController = TextEditingController();

  // Variables to store selected dropdown values
  String? _selectedTime;
  String? _selectedHour;
  String? _selectedCameraId;
  String? _patientName;
  String? _patientRoom;

  bool _isLoading = false;
  List<String> _cameraIds = [];

  @override
  void initState() {
    super.initState();
    _fetchCameraIds();
  }

  @override
  void dispose() {
    _videoUrlController.dispose();
    _patientNameController.dispose();
    _patientRoomController.dispose();
    super.dispose();
  }

  Future<void> _fetchCameraIds() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('Camera Informations')
          .orderBy('timestamp', descending: true) // Order by timestamp
          .get();

      setState(() {
        _cameraIds =
            snapshot.docs.map((doc) => doc['cameraId'] as String).toList();
        _isLoading = false;
      });
    } catch (e) {
      print("Error fetching camera IDs: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }


  // Fetch patient name with specific ID
  Future<void> _updatePatientName(String cameraId) async {
    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('Patient Informations')
          .where('cameraId', isEqualTo: cameraId)
          .limit(1)
          .get();
      if (snapshot.docs.isNotEmpty) {
        final doc = snapshot.docs.first.data() as Map<String, dynamic>;
        setState(() {
          _patientNameController.text = doc['patientName'] as String? ?? '';
          _patientRoomController.text = doc['room'] as String? ?? '';
        });
      } else {
        setState(() {
          _patientNameController.clear();
          _patientRoomController.clear();
        });
      }
    } catch (e) {
      print("Error fetching patient name: $e");
      setState(() {
        _patientNameController.clear();
        _patientRoomController.clear();
      });
    }
  }
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Add data to cameraDetails collection
        await FirebaseFirestore.instance.collection('Camera Informations').add({
          'cameraId': _selectedCameraId,
          'cameraUrl': _videoUrlController.text,
          'fallDetectionRecordTime':
              _selectedTime, // Save the selected time duration
          'cameraRecordTime': _selectedHour, // Save the selected hour duration
          'timestamp': FieldValue.serverTimestamp(),
        });

        // Clear form and reset state
        _formKey.currentState?.reset();
        _videoUrlController.clear();
        setState(() {
          _selectedTime = null;
          _selectedHour = null;
          _selectedCameraId = null;
          _patientName = null;
        });

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
                _buildCameraIdDropdown(),
                const SizedBox(height: 16),
                _buildPatientNameField(),
                const SizedBox(height: 16),
                _buildPatientRoomField(),
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

  Widget _buildCameraIdDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('カメラID',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          child: DropdownButtonFormField<String>(
            value: _selectedCameraId,
            decoration: const InputDecoration(
              border: InputBorder.none,
            ),
            items: _cameraIds.map((String cameraId) {
              return DropdownMenuItem<String>(
                value: cameraId,
                child: Text(cameraId),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedCameraId = newValue;
                _updatePatientName(newValue!);
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'カメラIDを選択してください';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPatientNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('対象者氏名',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          child: TextFormField(
            controller: _patientNameController,
            readOnly: true,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: _patientName ?? '対象者氏名', // Use null-aware operator
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPatientRoomField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('対象者の部屋',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          child: TextFormField(
            controller: _patientRoomController,
            readOnly: true,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: _patientRoom ?? '対象者の部屋', // Use null-aware operator
            ),
          ),
        ),
      ],
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
