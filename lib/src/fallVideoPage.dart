import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class FallVideoPage extends StatefulWidget {
  final String date;
  final String videoURL;
  final String cameraID;
  final String room;

  const FallVideoPage({
    Key? key,
    required this.date,
    required this.videoURL,
    required this.cameraID,
    required this.room,
  }) : super(key: key);

  @override
  _FallVideoPageState createState() => _FallVideoPageState();
}

class _FallVideoPageState extends State<FallVideoPage> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoURL)
      ..initialize().then((_) {
        setState(() {
          _controller.play(); // Auto-play the video
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '転倒検知ビデオ',
              style: TextStyle(
                fontSize: 24, // You can adjust this value as needed
                fontWeight: FontWeight.bold,
                color: Colors.black, // You can change the color if desired
              ),
            ),
            SizedBox(height: 20),
            _controller.value.isInitialized
                ? ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: 640,
                      maxHeight: 480,
                    ),
                    child: AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    ),
                  )
                : CircularProgressIndicator(),
            SizedBox(height: 20),
            VideoControls(controller: _controller),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class VideoControls extends StatefulWidget {
  final VideoPlayerController controller;

  const VideoControls({Key? key, required this.controller}) : super(key: key);

  @override
  _VideoControlsState createState() => _VideoControlsState();
}

class _VideoControlsState extends State<VideoControls> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _controlButton(
          icon: Icons.replay_10,
          onPressed: () {
            widget.controller.seekTo(
              widget.controller.value.position - const Duration(seconds: 10),
            );
          },
        ),
        _controlButton(
          icon: widget.controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
          onPressed: () {
            setState(() {
              if (widget.controller.value.isPlaying) {
                widget.controller.pause();
              } else {
                widget.controller.play();
              }
            });
          },
        ),
        _controlButton(
          icon: Icons.forward_10,
          onPressed: () {
            widget.controller.seekTo(
              widget.controller.value.position + const Duration(seconds: 10),
            );
          },
        ),
      ],
    );
  }

  Widget _controlButton({required IconData icon, required VoidCallback onPressed}) {
    return IconButton(
      icon: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Icon(
          icon,
          size: 35,
          color: Colors.orange,
        ),
      ),
      onPressed: onPressed,
    );
  }

  @override
  void dispose() {
    widget.controller.removeListener(() {});
    super.dispose();
  }
}