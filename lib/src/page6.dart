import 'package:flutter/material.dart';

class Page6 extends StatefulWidget {
  const Page6({super.key});

  @override
  State<Page6> createState() => _Page6State();
}

class _Page6State extends State<Page6> {
  bool isTextPressed = false;
  final _formKey = GlobalKey<FormState>();
  String? _selectedTime;
  String? _selectedHour;

  List<DropdownMenuItem<String>> _getTimeDropdownItems() {
    List<DropdownMenuItem<String>> items = [];
    for (int i = 1; i <= 60; i++) {
      items.add(DropdownMenuItem(
        value: i.toString(),
        child: Text('$i 分'),
      ));
    }
    return items;
  }

  List<DropdownMenuItem<String>> _getHourDropdownItems() {
    List<DropdownMenuItem<String>> items = [];
    for (int i = 1; i <= 24; i++) {
      items.add(DropdownMenuItem(
        value: i.toString(),
        child: Text('$i 時間'),
      ));
    }
    return items;
  }

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
                const SizedBox(height: 50.0),
                const Text('初期設定',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18)),
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
                    padding: const EdgeInsets.symmetric(
                        vertical: 30.0, horizontal: 350.0),
                    child: Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const SizedBox(height: 16),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  '転倒検知録画時間',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                    width: 70), // Adjust the spacing as needed
                                Container(
                                  width:
                                      150, // Set the width for the first dropdown
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.white,
                                  ),
                                  child: DropdownButtonFormField<String>(
                                    decoration: const InputDecoration(
                                      hintText: '15 分',
                                      border: InputBorder.none,
                                    ),
                                    value: _selectedTime,
                                    items: _getTimeDropdownItems(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        _selectedTime = newValue;
                                      });
                                    },
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return '落下録画時間を選択してください';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  '録画時間設定',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                    width: 102), // Adjust the spacing as needed
                                Container(
                                  width:
                                      150, // Set the width for the second dropdown
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.white,
                                  ),
                                  child: DropdownButtonFormField<String>(
                                    decoration: const InputDecoration(
                                      hintText: '24 時間',
                                      border: InputBorder.none,
                                    ),
                                    value: _selectedHour,
                                    items: _getHourDropdownItems(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        _selectedHour = newValue;
                                      });
                                    },
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return '録画時間を選択してください';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  'システム管理者ID',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                    width: 70), // Adjust the spacing as needed
                                Container(
                                  width:
                                      250, // Set the width for the text fields
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.white,
                                  ),
                                  child: TextFormField(
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'SV201223',
                                    ),
                                    keyboardType: TextInputType.text,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'IDを入力してください';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  'システム管理者氏名',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                    width:
                                        52.5), // Adjust the spacing as needed
                                Container(
                                  width:
                                      250, // Set the width for the text fields
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.white,
                                  ),
                                  child: TextFormField(
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: '平岡淳',
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return '名前を入力してください';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  'システム管理者PASS',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                    width: 45), // Adjust the spacing as needed
                                Container(
                                  width:
                                      250, // Set the width for the text fields
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
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
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFA67B5B),
                                    shape: BoxShape.circle,
                                  ),
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.add,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      // Handle add button press
                                    },
                                  ),
                                ),
                                const Text(
                                  '  追加',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 20),
                                ),
                              ],
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
