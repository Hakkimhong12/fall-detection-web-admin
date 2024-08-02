import 'package:flutter/material.dart';

class Page5 extends StatefulWidget {
  const Page5({super.key});

  @override
  State<Page5> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Page5> {
  bool isTextPressed = false;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Container(
            width: 250,
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
                const SizedBox(height: 50.0),
                const Text('アラートメール情報',
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
                const SizedBox(height: 230),
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
                        color: const Color(0xFFD9C1AE),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text('アラートメールに必要な情報',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20.0,
                              fontWeight: FontWeight.normal)),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 30.0, horizontal: 350.0),
                    child: Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const SizedBox(height: 16),
                            const Text(
                              'カメラID',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white,
                              ),
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'AZ201',
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'カメラIDを入力してください';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              '対象者氏名',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white,
                              ),
                              child: TextFormField(
                                obscureText: true,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: '山田はな',
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return '対象者名を入力してください';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              '動画を表示するURL',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white,
                              ),
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'http://www.gcp.com/.......',
                                ),
                                keyboardType: TextInputType.url,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'URLを入力してください';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'ログインID',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white,
                              ),
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'AZ20I',
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'IDを入力してください';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'ログインパスワード',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white,
                              ),
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: '*****',
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'パスワードを入力してください';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              '場所',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white,
                              ),
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: '102号室',
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return '部屋に入ってください';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 25, horizontal: 40),
                                    foregroundColor: Colors.black,
                                    backgroundColor: const Color(
                                        0xFFD9C1AE), // background color
                                  ),
                                  onPressed: () {
                                    Navigator.pop(
                                        context); // Handle back button press
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
                                  ),
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      // Process data
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
    );
  }
}
