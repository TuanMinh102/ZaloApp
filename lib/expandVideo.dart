import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoApp extends StatefulWidget {
  final String videoLink;
  const VideoApp({super.key, required this.videoLink});

  @override
  State<VideoApp> createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoApp> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoLink))
      ..initialize().then((_) {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Stack(alignment: AlignmentDirectional.center, children: [
            GestureDetector(
              onTap: () => {
                setState(() {
                  if (_controller.value.isPlaying) {
                    _controller.pause();
                  } else {
                    _controller.play();
                  }
                })
              },
              child: AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              ),
            ),
            if (!_controller.value.isPlaying)
              FloatingActionButton(
                onPressed: () {
                  setState(() {
                    _controller.play();
                  });
                },
                child: Icon(
                  _controller.value.isPlaying ? null : Icons.play_arrow,
                ),
              ),
          ]),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
