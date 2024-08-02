import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class Page3 extends StatefulWidget {
  final int initialImageIndex;
  final List<String> imagePaths;
  final List<String> cameraIds;
  final List<String> targets;
  final List<String> locations;
  final List<String> videoPaths; 

  const Page3({
    super.key,
    required this.initialImageIndex,
    required this.imagePaths,
    required this.cameraIds,
    required this.targets,
    required this.locations,
    required this.videoPaths, 
  });

  @override
  State<Page3> createState() => _Page3State();
}

class _Page3State extends State<Page3> {
  bool isTextPressed = false;
  late int currentImageIndex;
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    currentImageIndex = widget.initialImageIndex;
    _controller = VideoPlayerController.asset(widget.videoPaths[currentImageIndex]);
    _initializeVideoPlayerFuture = _controller.initialize().then((_) {
      setState(() {});
    });
    _controller.setLooping(true);
  }

  void _showNextVideo() {
    setState(() {
      currentImageIndex = (currentImageIndex + 1) % widget.videoPaths.length;
      _controller = VideoPlayerController.asset(widget.videoPaths[currentImageIndex]);
      _initializeVideoPlayerFuture = _controller.initialize();
      _controller.setLooping(true);
    });
  }

  void _showPreviousVideo() {
    setState(() {
      currentImageIndex = (currentImageIndex - 1 + widget.videoPaths.length) %
          widget.videoPaths.length;
      _controller = VideoPlayerController.asset(widget.videoPaths[currentImageIndex]);
      _initializeVideoPlayerFuture = _controller.initialize();
      _controller.setLooping(true);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
                        color: isTextPressed ? Colors.black : Colors.black,
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
                          FutureBuilder(
                            future: _initializeVideoPlayerFuture,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.done) {
                                return Container(
                                  width: 370,
                                  height: 290,
                                  child: AspectRatio(
                                    aspectRatio: _controller.value.aspectRatio,
                                    child: VideoPlayer(_controller),
                                  ),
                                );
                              } else {
                                return const Center(child: CircularProgressIndicator());
                              }
                            },
                          ),
                          const SizedBox(height: 20.0),
                          ElevatedButton(
                            onPressed: (){
                              setState(() {
                                if(_controller.value.isPlaying){
                                  _controller.pause();
                                }else {
                                  _controller.play();
                                }
                              });
                            },
                              child: Icon(
                                _controller.value.isPlaying? Icons.pause : Icons.play_arrow,
                              ),
                          ),
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
