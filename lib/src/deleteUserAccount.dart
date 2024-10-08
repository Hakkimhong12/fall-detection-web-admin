import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class deleteUserAccount extends StatefulWidget {
  const deleteUserAccount({super.key});

  @override
  State<deleteUserAccount> createState() => _deleteUserAccountState();
}

class _deleteUserAccountState extends State<deleteUserAccount> {
  bool _isLoading = false;
  List<Map<String, String>> _users = [];
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  // Fetch all users from 'User Informations' collection
  Future<void> _fetchUsers() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('User Informations')
          .get();

      setState(() {
        _users = snapshot.docs.map((doc) {
          return {
            'id': doc.id,
            'userName': doc['userName'] as String,
            'email': doc['email'] as String,
            'phoneNumber': doc['phoneNumber'] as String,
          };
        }).toList();
        _isLoading = false;
      });

      if (_users.isEmpty) {
        setState(() {
          _error = 'No users found.';
        });
      }
    } catch (e) {
      print("Error fetching users: $e");
      setState(() {
        _isLoading = false;
        _error = 'Failed to fetch users. Please try again.';
      });
    }
  }

  // Delete user and associated data
  Future<void> _deleteUser(String userId) async {
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
        // Step 1: Delete the user information from Firestore
        final userDoc = FirebaseFirestore.instance
            .collection('User Informations')
            .doc(userId);
        final userData = await userDoc.get();
        final userEmail = userData['email'];

        // Step 2: Delete related documents in 'Camera Access' collection
        await FirebaseFirestore.instance
            .collection('Camera Access')
            .where('userUid', isEqualTo: userId)
            .get()
            .then((snapshot) {
          for (DocumentSnapshot doc in snapshot.docs) {
            doc.reference.delete();
          }
        });

        // Step 3: Delete related documents in 'Patient Family' collection
        await FirebaseFirestore.instance
            .collection('Patient Family')
            .where('userUid', isEqualTo: userId)
            .get()
            .then((snapshot) {
          for (DocumentSnapshot doc in snapshot.docs) {
            doc.reference.delete();
          }
        });

        // Step 4: Delete user document from 'User Informations'
        await userDoc.delete();

        // Step 5: Delete user from Firebase Authentication
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null && user.email == userEmail) {
          await user.delete();
        }

        // Refresh the list of users
        await _fetchUsers();

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ユーザーアカウントと関連情報が削除されました')),
        );
      } catch (e) {
        // Handle any errors
        print('Error deleting user account and related data: $e');
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

  Future<void> _updateUser(String userId, String newUserName, String newEmail, String newPhoneNumber) async {
    try {
      // Update only specific fields
      await FirebaseFirestore.instance
          .collection('User Informations')
          .doc(userId)
          .update({
        'userName': newUserName,
        'email': newEmail,
        'phoneNumber': newPhoneNumber,
      });

      // Optional: Update the email in Firebase Authentication as well
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.updateEmail(newEmail);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ユーザー情報が更新されました')),
      );
    } catch (e) {
      print('Error updating user: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ユーザー情報の更新に失敗しました')),
      );
    }
  }

  // Edit user dialog
  Future<void> _showEditDialog(Map<String, String> user) async {
    final TextEditingController userNameController = TextEditingController(text: user['userName']);
    final TextEditingController emailController = TextEditingController(text: user['email']);
    final TextEditingController phoneNumberController = TextEditingController(text: user['phoneNumber']);

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ユーザー情報を編集'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: userNameController,
                  decoration: const InputDecoration(labelText: 'ユーザー名'),
                ),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'メールアドレス'),
                ),
                TextField(
                  controller: phoneNumberController,
                  decoration: const InputDecoration(labelText: '電話番号'),
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
                _updateUser(
                  user['id']!,
                  userNameController.text,
                  emailController.text,
                  phoneNumberController.text,
                );
                Navigator.of(context).pop();
                _fetchUsers(); // Refresh the list after updating
              },
            ),
          ],
        );
      },
    );
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
              const Text('ユーザー情報管理',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18)),
              const SizedBox(height: 30),
              _buildSidebarButton('患者情報管理', '/deletepatient'),
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

  // User Cards
  Widget _buildUserCards() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_users.isEmpty) {
      return Center(
        child: Text(
          _error ?? 'No users found.',
          style: const TextStyle(fontSize: 18, color: Colors.red),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: _users.length,
      itemBuilder: (context, index) {
        final user = _users[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Align(
            alignment: Alignment.center,  // Center the card if necessary
            child: SizedBox(
              width: 730, // Set your preferred width here
              height: 100, // Set your preferred height here
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
                            'ユーザー名: ${user['userName'] ?? ''}',
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.orange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '電話番号: ${user['phoneNumber'] ?? ''}',
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.black45,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'メールアドレス: ${user['email'] ?? ''}',
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
                          onPressed: () => _showEditDialog(user),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteUser(user['id']!),
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
                      child: const Text('ユーザー情報管理',
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
                    child: _buildUserCards(),
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
