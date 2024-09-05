import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class deleteUserAccount extends StatefulWidget {
  const deleteUserAccount({super.key});

  @override
  State<deleteUserAccount> createState() => _deleteUserAccountState();
}

class _deleteUserAccountState extends State<deleteUserAccount> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for form fields
  final TextEditingController _patientNameController = TextEditingController();
  final TextEditingController _patientRoomController = TextEditingController();

  // Variables to store selected dropdown values
  String? _selectedUserName;
  String? _selectedCameraId;
  String? _patientName;
  String? _patientRoom;

  bool _isLoadingUserNames = false;
  bool _isLoadingUserInfo = false;
  bool _isLoading = false;
  List<String> _userNames = [];
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchUserNames();
  }

  @override
  void dispose() {
    _patientNameController.dispose();
    _patientRoomController.dispose();
    super.dispose();
  }

  // Fetch all usernames from 'User Information' collection
  Future<void> _fetchUserNames() async {
    setState(() {
      _isLoadingUserNames = true;
      _error = null;
    });

    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('User Informations')
          .get();

      setState(() {
        _userNames = snapshot.docs
            .map((doc) => doc['userName'] as String?)
            .where((userName) => userName != null)
            .cast<String>()
            .toList();
        _isLoadingUserNames = false;
      });

      if (_userNames.isEmpty) {
        setState(() {
          _error = 'No usernames found.';
        });
      }
    } catch (e) {
      print("Error fetching user names: $e");
      setState(() {
        _isLoadingUserNames = false;
        _error = 'Failed to fetch usernames. Please try again.';
      });
    }
  }

  // Fetch cameraId and patient info based on selected username
  Future<void> _updatePatientInfo(String userName) async {
    setState(() {
      _isLoadingUserInfo = true;
      _error = null;
    });

    try {
      // Fetch userUid by using selected username from 'User Informations'
      final QuerySnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('User Informations')
          .where('userName', isEqualTo: userName)
          .limit(1)
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        final userDoc = userSnapshot.docs.first;
        final userUid = userDoc.id;

        // Fetch cameraId from 'Camera Access' by using userUid
        final QuerySnapshot cameraSnapshot = await FirebaseFirestore.instance
            .collection('Camera Access')
            .where('userUid', isEqualTo: userUid)
            .limit(1)
            .get();

        if (cameraSnapshot.docs.isNotEmpty) {
          final cameraDoc =
              cameraSnapshot.docs.first.data() as Map<String, dynamic>;
          final cameraId = cameraDoc['cameraId'] as String?;

          if (cameraId != null) {
            // Fetch patient info from 'Patient Informations' by using cameraId
            final QuerySnapshot patientSnapshot = await FirebaseFirestore
                .instance
                .collection('Patient Informations')
                .where('cameraId', isEqualTo: cameraId)
                .limit(1)
                .get();

            if (patientSnapshot.docs.isNotEmpty) {
              final patientDoc =
                  patientSnapshot.docs.first.data() as Map<String, dynamic>;
              setState(() {
                _selectedCameraId = cameraId;
                _patientNameController.text =
                    patientDoc['patientName'] as String? ?? '';
                _patientRoomController.text =
                    patientDoc['room'] as String? ?? '';
              });
            } else {
              _clearPatientInfo(
                  'No patient information found for this camera.');
            }
          } else {
            _clearPatientInfo('No camera ID found for this user.');
          }
        } else {
          _clearPatientInfo(
              'No camera access information found for this user.');
        }
      } else {
        _clearPatientInfo('User not found.');
      }
    } catch (e) {
      print("Error fetching patient info: $e");
      _clearPatientInfo('Error fetching information. Please try again.');
    } finally {
      setState(() {
        _isLoadingUserInfo = false;
      });
    }
  }

  void _clearPatientInfo(String errorMessage) {
    setState(() {
      _selectedCameraId = null;
      _patientNameController.clear();
      _patientRoomController.clear();
      _error = errorMessage;
    });
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Show confirmation dialog
      bool? confirmDelete = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('確認'),
            content: const Text('本当にこのユーザーアカウントを削除しますか？この操作は元に戻せません。'),
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
          // Start a new batch
          WriteBatch batch = FirebaseFirestore.instance.batch();

          // 1. Find and prepare to delete user information from 'User Informations'
          final QuerySnapshot userSnapshot = await FirebaseFirestore.instance
              .collection('User Informations')
              .where('userName', isEqualTo: _selectedUserName)
              .limit(1)
              .get();

          if (userSnapshot.docs.isNotEmpty) {
            final userDoc = userSnapshot.docs.first;
            final userUid = userDoc.id;

            // Add user document deletion to batch
            batch.delete(userDoc.reference);

            // 2. Find and prepare to delete related information from 'Patient Family'
            final QuerySnapshot patientFamilySnapshot = await FirebaseFirestore
                .instance
                .collection('Patient Family')
                .where('userUid', isEqualTo: userUid)
                .get();

            for (var patientFamilyDoc in patientFamilySnapshot.docs) {
              final patientDocumentId = patientFamilyDoc['patientDocumentId'];

              // 3. Prepare to delete patient information from 'Patient Informations'
              batch.delete(FirebaseFirestore.instance
                  .collection('Patient Informations')
                  .doc(patientDocumentId));

              // Add patient family document deletion to batch
              batch.delete(patientFamilyDoc.reference);
            }

            // 4. Find and prepare to delete camera access information from 'Camera Access'
            final QuerySnapshot cameraAccessSnapshot = await FirebaseFirestore
                .instance
                .collection('Camera Access')
                .where('userUid', isEqualTo: userUid)
                .get();

            for (var cameraAccessDoc in cameraAccessSnapshot.docs) {
              batch.delete(cameraAccessDoc.reference);
            }

            // Commit the batch
            await batch.commit();

            // Clear form and reset state
            _formKey.currentState?.reset();
            setState(() {
              _selectedUserName = null;
              _selectedCameraId = null;
              _patientNameController.clear();
              _patientRoomController.clear();
            });

            // Refresh the list of usernames
            await _fetchUserNames();

            // Show success message
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('ユーザーアカウントと関連情報が削除されました')),
            );
          } else {
            // User not found
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('ユーザーが見つかりませんでした')),
            );
          }
        } catch (e) {
          // Handle any errors
          print('Error deleting user account: $e');
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
              const SizedBox(height: 40),
              _buildSidebarButton('カメラ登録', '/page5'),
              const SizedBox(height: 40.0),
              const Text('ユーザーアカウント削除',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18)),
              const SizedBox(height: 40),
              _buildSidebarButton('初期設定', '/page6'),
              const SizedBox(height: 40),
              _buildSidebarButton('Fall History', '/notification'),
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
                _buildUserNameDropdown(),
                const SizedBox(height: 16),
                _buildCameraIdField(),
                const SizedBox(height: 16),
                _buildPatientNameField(),
                const SizedBox(height: 16),
                _buildPatientRoomField(),
                const SizedBox(height: 16),
                _buildFormButtons(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildUserNameDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('ユーザー名',
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
            value: _selectedUserName,
            decoration: const InputDecoration(
              border: InputBorder.none,
            ),
            items: _userNames.map((String userName) {
              return DropdownMenuItem<String>(
                value: userName,
                child: Text(userName),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  _selectedUserName = newValue;
                });
                _updatePatientInfo(newValue);
              }
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'ユーザー名を選択してください';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCameraIdField() {
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
          child: TextFormField(
            controller: TextEditingController(
                text:
                    _selectedCameraId), // Using _selectedCameraId to display camera ID
            readOnly: true,
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: 'カメラID', // Hint text for camera ID
            ),
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
                          child: const Text('システムからユーザーアカウントを削除',
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
              if (_isLoading || _isLoadingUserInfo)
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
