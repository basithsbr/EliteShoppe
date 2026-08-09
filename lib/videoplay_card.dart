import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerCard extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerCard({super.key, required this.videoUrl});

  @override
  State<VideoPlayerCard> createState() => _VideoPlayerCardState();
}

class _VideoPlayerCardState extends State<VideoPlayerCard> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();

    String webPath = widget.videoUrl;
    if (webPath.startsWith('/')) {
      webPath = webPath.substring(1);
    }

    if (!webPath.startsWith('assets/')) {
      webPath = 'assets/$webPath';
    }
    _controller = VideoPlayerController.asset(webPath)
      // _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize()
          .then((_) {
            _controller.setVolume(
              0.0,
            ); // MUST be muted for browser autoplay clearance
            _controller.setLooping(true);
            setState(() {
              _isInitialized = true;
            });
            _controller.play();
          })
          .catchError((error) {
            print("Web Engine Render Error: $error");
          });
  }

  @override
  void dispose() {
    _controller.dispose(); // Prevents memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return Container(
        color: Colors.black12,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        // Enforces the video's natural shape inside your 16:9 layout boundary
        // AspectRatio(
        //   aspectRatio: _controller.value.aspectRatio,
        //   child: VideoPlayer(_controller),
        // ),
        SizedBox.expand(
          child: FittedBox(
            fit: BoxFit
                .cover, // Expands and crops smoothly to maintain full width
            child: SizedBox(
              width: _controller.value.size.width,
              height: _controller.value.size.height,
              child: VideoPlayer(_controller),
            ),
          ),
        ),

        // Optional: Tap overlay to play/pause manually
        GestureDetector(
          onTap: () {
            setState(() {
              _controller.value.isPlaying
                  ? _controller.pause()
                  : _controller.play();
            });
          },
          child: Container(
            color: Colors.transparent,
            child: Center(
              child: _controller.value.isPlaying
                  ? const SizedBox.shrink()
                  : const Icon(
                      Icons.play_arrow,
                      size: 50,
                      color: Colors.white70,
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
