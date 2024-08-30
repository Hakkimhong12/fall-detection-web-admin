import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fall_detection_web_admin/api/camera_api.dart';
import 'package:flutter/material.dart';
import 'package:fall_detection_web_admin/src/page3.dart';

class Page2 extends StatefulWidget {
  const Page2({super.key});

  @override
  State<Page2> createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  bool isTextPressed = false;
  List<String> imagePaths = [];
  List<String> cameraIds = [];
  List<String> targets = [];
  List<String> locations = [];


  void _fetchCameraDetails() async {
    final CameraIdApi api = CameraIdApi();
    final QuerySnapshot snapshot = await api.getCameraDetailsOnce();
    final List<DocumentSnapshot> documents = snapshot.docs;

    setState(() {
      for (var doc in documents) {
        imagePaths.add(doc['imageUrl']);
        cameraIds.add(doc['cameraId']);
        targets.add(doc['targetName']);
        locations.add(doc['location']);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchCameraDetails();
  }


  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        NavigationPanel(
          isTextPressed: isTextPressed,
          onItemPressed: (route) {
            Navigator.pushNamed(context, route);
          },
        ),
        Expanded(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 490, top: 30),
                child: Header(title: 'カメラの全画面表示'),
              ),
              SizedBox(
                width: 1000,
                height: 600,
                child: GridView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 4 / 3,
                    crossAxisSpacing: 80,
                    mainAxisSpacing: 40,
                  ),
                  itemCount: imagePaths.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Page3(
                              initialImageIndex: index,
                              imagePaths: imagePaths,
                              cameraIds: cameraIds,
                              targets: targets,
                              locations: locations,
                              // videoPaths: videoPaths,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        color: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 4.0),
                              child: Text(
                                locations[index],
                                style: const TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 10,
                                  decoration: TextDecoration.none,
                                  color: Colors.black,
                                  backgroundColor: Colors.transparent,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black),
                                  borderRadius: BorderRadius.circular(4),
                                  image: DecorationImage(
                                    image: NetworkImage(imagePaths[index]),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class NavigationPanel extends StatelessWidget {
  final bool isTextPressed;
  final Function(String) onItemPressed;

  const NavigationPanel({
    required this.isTextPressed,
    required this.onItemPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFA67B5B),
        border: Border.all(
          color: Colors.grey,
          width: 2,
        ),
      ),
      width: 250,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50.0),
            GestureDetector(
              onTap: () => onItemPressed('/page1'),
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
            const Text('カメラの全画面表示',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.none)),
            const SizedBox(height: 70),
            GestureDetector(
              onTap: () => onItemPressed('/page4'),
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
              onTap: () => onItemPressed('/page5'),
              child: Text(
                'カメラ登録',
                style: TextStyle(
                    color: isTextPressed ? Colors.black : Colors.white,
                    fontWeight: FontWeight.normal,
                    fontSize: 18,
                    decoration: TextDecoration.none),
              ),
            ),
            const SizedBox(height: 50),
            GestureDetector(
              onTap: () => onItemPressed('/page6'),
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
              onTapDown: (_) => onItemPressed('/notification'),
              child: Text(
                '通知',
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
                  decoration: TextDecoration.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Header extends StatelessWidget {
  final String title;

  const Header({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Align(
        alignment: Alignment.topLeft,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFD9C1AE),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.normal,
              decoration: TextDecoration.none,
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }
}
