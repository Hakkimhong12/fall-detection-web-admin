import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'dart:html';
import 'package:cloud_firestore/cloud_firestore.dart';

class Page3 extends StatefulWidget {
  final int initialImageIndex;
  final List<String> imagePaths;
  final List<String> cameraIds;
  final List<String> targets;
  final List<String> locations;

  const Page3({
    super.key,
    required this.initialImageIndex,
    required this.imagePaths,
    required this.cameraIds,
    required this.targets,
    required this.locations,
  });

  @override
  State<Page3> createState() => _Page3State();
}

class _Page3State extends State<Page3> {
  bool isTextPressed = false;
  late int currentImageIndex;
  String? currentVideoUrl;

  @override
  void initState() {
    super.initState();
    currentImageIndex = widget.initialImageIndex;
    _loadVideoUrl();
  }

  Future<void> _loadVideoUrl() async {
    String cameraId = widget.cameraIds[currentImageIndex];
    print('Fetching document with cameraId: $cameraId');

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Camera Informations')
        .where('cameraId', isEqualTo: cameraId)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
      setState(() {
        currentVideoUrl = documentSnapshot['cameraUrl'];
        _registerVideoView();
      });
    } else {
      print('Document does not exist for cameraId: $cameraId');
    }
  }


  void _registerVideoView() {
    if (currentVideoUrl != null) {
      ui.platformViewRegistry.registerViewFactory(
        'mjpeg-video-$currentImageIndex',
        (int viewId) => IFrameElement()
          ..src = currentVideoUrl
          ..style.border = 'none',
      );
    }
  }

  void _showNextVideo() async {
    setState(() {
      currentImageIndex = (currentImageIndex + 1) % widget.cameraIds.length;
    });
    await _loadVideoUrl();
  }

  void _showPreviousVideo() async {
    setState(() {
      currentImageIndex = (currentImageIndex - 1 + widget.cameraIds.length) %
          widget.cameraIds.length;
    });
    await _loadVideoUrl();
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
                        color: isTextPressed ? Colors.black : Colors.black,
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
                    Navigator.pushNamed(context, '/registrationExistingUser');
                  },
                  onTapCancel: () {
                    setState(() {
                      isTextPressed = false;
                    });
                  },
                  child: Text(
                    '既存ユーザーの患者登録',
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
                    Navigator.pushNamed(context, '/deleteUserAccoount');
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
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(75.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 29.0, vertical: 8.0),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD9C1AE),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text('カメラID'),
                        ),
                        const SizedBox(width: 16.0),
                        Text(widget.cameraIds[currentImageIndex]),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 35.0, vertical: 8.0),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD9C1AE),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text('対象者'),
                        ),
                        const SizedBox(
                          width: 16.0,
                        ),
                        Text(widget.targets[currentImageIndex]),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40.0, vertical: 8.0),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD9C1AE),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text('場所'),
                        ),
                        const SizedBox(width: 16.0),
                        Text(widget.locations[currentImageIndex]),
                      ],
                    ),
                    const SizedBox(height: 50.0),
                    Center(
                      child: Column(
                        children: [
                          if (currentVideoUrl != null)
                            SizedBox(
                              width: 640,
                              height: 480,
                              child: HtmlElementView(viewType: 'mjpeg-video-$currentImageIndex'),
                            )
                          else
                            const CircularProgressIndicator(),
                          const SizedBox(height: 20.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                onPressed: _showPreviousVideo,
                                icon: const Icon(Icons.arrow_back_ios),
                              ),
                              IconButton(
                                onPressed: _showNextVideo,
                                icon: const Icon(Icons.arrow_forward_ios),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
