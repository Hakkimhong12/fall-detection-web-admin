import 'package:fall_detection_web_admin/src/deleteUserAccount.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DeletePatient extends StatefulWidget {
  const DeletePatient({super.key});

  @override
  State<DeletePatient> createState() => _deletePatientState();
}

class _deletePatientState extends State<DeletePatient> {
  bool _isLoading = false;
  List<Map<String, String>> _patients = [];
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchPatients();
  }

  Future<void> _fetchPatients() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('Patient Informations')
          .get();

      setState(() {
        _patients = snapshot.docs.map((doc) {
          return {
            'id': doc.id,
            'patientName': doc['patientName'] as String,
            'room': doc['room'] as String,
            'cameraId': doc['cameraId'] as String,
          };
        }).toList();
        _isLoading = false;
      });

      if (_patients.isEmpty) {
        setState(() {
          _error = 'No patients found.';
        });
      }
    } catch (e) {
      print("Error fetching patients: $e");
      setState(() {
        _isLoading = false;
        _error = 'Failed to fetch patients. Please try again.';
      });
    }
  }

  // Delete patient and associated data
  Future<void> _deletePatient(String patientId) async {
    bool? confirmDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('確認'),
          content: const Text('本当にこの患者情報を削除しますか？この操作は元に戻せません。'),
          actions: <Widget>[
            TextButton(
              child: const Text('キャンセル'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: const Text('削除'),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );

    if (confirmDelete == true) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Delete patient information from 'Patient Informations'
        await FirebaseFirestore.instance
            .collection('Patient Informations')
            .doc(patientId)
            .delete();

        // Refresh the list of patients
        await _fetchPatients();

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('患者情報が削除されました')),
        );
      } catch (e) {
        // Handle any errors
        print('Error deleting patient information: $e');
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

  Future<void> _showEditDialog(Map<String, dynamic> patient) async {
    final TextEditingController patientNameController = TextEditingController(text: patient['patientName']);
    final TextEditingController roomController = TextEditingController(text: patient['room']);
    final TextEditingController cameraIdController = TextEditingController(text: patient['cameraId']);

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('患者情報を編集'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: patientNameController,
                  decoration: const InputDecoration(labelText: '患者名'),
                ),
                TextField(
                  controller: roomController,
                  decoration: const InputDecoration(labelText: '部屋番号'),
                ),
                TextField(
                  controller: cameraIdController,
                  decoration: const InputDecoration(labelText: 'カメラID'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('キャンセル'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('保存'),
              onPressed: () {
                _updatePatient(
                  patient['id'],
                  patientNameController.text,
                  roomController.text,
                  cameraIdController.text,
                );
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Update patient information
  Future<void> _updatePatient(String patientId, String newPatientName, String newRoom, String newCameraId) async {
    try {
      await FirebaseFirestore.instance
          .collection('Patient Informations')
          .doc(patientId)
          .update({
        'patientName': newPatientName,
        'room': newRoom,
        'cameraId': newCameraId,
      });

      // Refresh the list of patients
      await _fetchPatients();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('患者情報が更新されました')),
      );
    } catch (e) {
      print('Error updating patient: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('患者情報の更新に失敗しました')),
      );
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
              const SizedBox(height: 50),
              _buildSidebarButton('カメラの全画面表示', '/page2'),
              const SizedBox(height: 50),
              _buildSidebarButton('アラートメール確認者登録', '/page4'),
              const SizedBox(height: 30),
              _buildSidebarButton('既存ユーザーの患者登録', '/registrationExistingUser'),
              const SizedBox(height: 30),
              _buildSidebarButton('カメラ登録', '/page5'),
              const SizedBox(height: 30),
              _buildSidebarButton('ユーザー情報管理', '/deleteUserAccount'),
              const SizedBox(height: 30),
              const Text('患者情報管理',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18)),
              const SizedBox(height: 30),
              _buildSidebarButton('初期設定', '/page6'),
              const SizedBox(height: 30),
              _buildSidebarButton('転倒検知履歴', '/notification'),
              const SizedBox(height: 100),
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

  // Patient Cards
  Widget _buildPatientCards() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_patients.isEmpty) {
      return Center(
        child: Text(
          _error ?? 'No patients found.',
          style: const TextStyle(fontSize: 18, color: Colors.red),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: _patients.length,
      itemBuilder: (context, index) {
        final patient = _patients[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: 730,
              height: 90,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.shade200.withOpacity(0.8),
                      blurRadius: 10,
                      spreadRadius: 1,
                      offset: const Offset(5, 6),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '患者名: ${patient['patientName']}',
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.orange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '部屋 : ${patient['room']}',
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.black45,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'カメラID: ${patient['cameraId']}',
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.black45,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _showEditDialog(patient),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deletePatient(patient['id']!),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          _buildSidebar(context),
          Expanded(
            child: Column(
              children: [
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
                      child: const Text('患者情報管理 ',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20.0,
                              fontWeight: FontWeight.normal)),
                    ),
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: _buildPatientCards(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
