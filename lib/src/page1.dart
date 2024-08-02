import 'package:flutter/material.dart';

class Page1 extends StatefulWidget {
  const Page1({super.key});

  @override
  State<Page1> createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  bool isTextPressed = false;
  int currentPage = 1;
  final int itemPerPage = 5;
  final int numberOfPages = 12;

  @override
  Widget build(BuildContext context) {
    final List<String> imagePaths = [
      'assets/images/image1.jpg',
      'assets/images/image2.jpg',
      'assets/images/image3.jpg',
      'assets/images/image4.jpg',
      'assets/images/img5.jpg',
      'assets/images/img6.jpg'
    ];

    return Row(
      children: [
        NavigationPanel(
          isTextPressed: isTextPressed,
          onItemPressed: (route) {
            Navigator.pushNamed(context, route);
          },
        ),
        Expanded(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.only(left: 200),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Header(title: 'アラートメール登録者一覧'),
                const SizedBox(height: 10),
                Expanded(
                  child: SizedBox(
                    width: 380,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(20.0),
                      itemCount: numberOfPages,
                      //itemCount: imagePaths.length,
                      itemBuilder: (context, index) {
                        if (index == itemPerPage) {
                          return PaginationControls(
                            currentPage: currentPage,
                            numberOfPages: numberOfPages,
                            onPageChanged: (newPage) {
                              setState(() {
                                currentPage = newPage;
                              });
                            },
                          );
                        }
                        int actualIndex =
                            (currentPage - 1) * itemPerPage + index;
                        if (actualIndex >= imagePaths.length) {
                          return Container();
                        }
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 30.0),
                          child: CameraDetails(
                            cameraId: 'A0${121 + index}',
                            targetName: [
                              '前川さつ',
                              '福田隆',
                              '平林美智子',
                              '山田はな',
                              '高橋健'
                            ][actualIndex % 5],
                            location: '部屋番号 ${202 + actualIndex * 2}',
                            imagePath: imagePaths[actualIndex % 5],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class PaginationControls extends StatelessWidget {
  final int currentPage;
  final int numberOfPages;
  final Function(int) onPageChanged;

  const PaginationControls({
    required this.currentPage,
    required this.numberOfPages,
    required this.onPageChanged,
    super.key,
  });

  List<Widget> _buildPageItems() {
    List<Widget> pageItems = [];
    if (numberOfPages <= 5) {
      for (int i = 1; i <= numberOfPages; i++) {
        pageItems.add(_buildPageNumber(i));
      }
    } else {
      if (currentPage > 3) {
        pageItems.add(_buildPageNumber(1));
        pageItems.add(_buildPageNumber(2));
        pageItems.add(const Text('...', style: TextStyle(color: Colors.grey, fontSize: 12, backgroundColor: Colors.transparent, decoration: TextDecoration.none)));
      }
      for (int i = currentPage - 1; i <= currentPage + 1; i++) {
        if (i > 0 && i <= numberOfPages) {
          pageItems.add(_buildPageNumber(i));
        }
      }
      if (currentPage < numberOfPages - 2) {
        pageItems.add(const Text('...', style: TextStyle(color: Colors.grey, fontSize: 12, backgroundColor: Colors.transparent, decoration: TextDecoration.none)));
        pageItems.add(_buildPageNumber(numberOfPages - 1));
        pageItems.add(_buildPageNumber(numberOfPages));
      }
    }
    return pageItems;
  }

  Widget _buildPageNumber(int pageNumber) {
    return GestureDetector(
      onTap: () {
        onPageChanged(pageNumber);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 5.0),
        padding: const EdgeInsets.all(6.0),
        decoration: BoxDecoration(
          color: currentPage == pageNumber ? const Color(0xFFA67B5B) : Colors.white,
          borderRadius: BorderRadius.circular(4.0),
          border: Border.all(
            color: currentPage == pageNumber ? const Color(0xFFA67B5B) : Colors.grey,
            width: 1,
          ),
        ),
        child: Text(
          pageNumber.toString(),
          style: TextStyle(
            fontSize: 12,
            color: currentPage == pageNumber ? Colors.white : Colors.grey,
            decoration: TextDecoration.none,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          color: Colors.grey,
          onPressed: currentPage > 1
              ? () {
                  onPageChanged(currentPage - 1);
                }
              : null,
        ),
        ..._buildPageItems(),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          color: Colors.grey,
          onPressed: currentPage < numberOfPages
              ? () {
                  onPageChanged(currentPage + 1);
                }
              : null,
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
            const Text(
              'AIカメラ管理画面',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.none,
              ),
            ),
            const SizedBox(height: 100),
            GestureDetector(
              onTapDown: (_) => onItemPressed('/page2'),
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
              onTapDown: (_) => onItemPressed('/page4'),
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
              onTapDown: (_) => onItemPressed('/page5'),
              child: Text(
                'アラートメール情報',
                style: TextStyle(
                    color: isTextPressed ? Colors.black : Colors.white,
                    fontWeight: FontWeight.normal,
                    fontSize: 18,
                    decoration: TextDecoration.none),
              ),
            ),
            const SizedBox(height: 50),
            GestureDetector(
              onTapDown: (_) => onItemPressed('/page6'),
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
      padding: const EdgeInsets.only(top: 40),
      child: Container(
        width: 370,
        height: 40,
        decoration: const BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 25,
              decoration: TextDecoration.none,
            ),
          ),
        ),
      ),
    );
  }
}

class CameraDetails extends StatelessWidget {
  final String cameraId;
  final String targetName;
  final String location;
  final String imagePath;

  const CameraDetails({
    required this.cameraId,
    required this.targetName,
    required this.location,
    required this.imagePath,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'カメラID',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                    decoration: TextDecoration.none,
                  ),
                ),
                const SizedBox(width: 33),
                Container(
                  width: 100,
                  height: 25,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Text(
                    cameraId,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                const Text(
                  '対象者',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                    decoration: TextDecoration.none,
                  ),
                ),
                const SizedBox(width: 49),
                Container(
                  width: 100,
                  height: 25,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Text(
                    targetName,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                const Text(
                  '場所',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                    decoration: TextDecoration.none,
                  ),
                ),
                const SizedBox(width: 67),
                Container(
                  width: 100,
                  height: 25,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Text(
                    location,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(width: 35),
        Expanded(
          child: SizedBox(
            width: 80,
            height: 95,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.black,
                  width: 1,
                ),
              ),
              child: Image.asset(
                imagePath,
                //fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
