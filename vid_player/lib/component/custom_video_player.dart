import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class CustomVideoPlayer extends StatefulWidget {
  final XFile video;

  const CustomVideoPlayer({required this.video, super.key});

  @override
  State<CustomVideoPlayer> createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  VideoPlayerController? vidoeController;

  @override
  void initState() {
    super.initState();

    initializeController(); // initState에는 직접 async 달 수 없음
  }

  initializeController() async {
    vidoeController = VideoPlayerController.file(
      File(
        widget.video.path, // XFile의 경로를 넣어 dart.io의 File 형태로 변경
      ),
    );

    await vidoeController!.initialize();

    setState(() {}); // vidoeController 생성되었으니 build를 다시 호출하기 위해
  }

  @override
  Widget build(BuildContext context) {
    if (vidoeController == null) {
      return const CircularProgressIndicator();
    }
    return Stack(
      children: [
        AspectRatio(
          aspectRatio: vidoeController!.value.aspectRatio,
          child: VideoPlayer(vidoeController!),
        ),
        _Controls(
          onPlayPressed: onPlayPressed,
          onReversePressed: onReversePressed,
          onForwardPressed: onForwardPressed,
          isPlaying: vidoeController!.value.isPlaying,
        ),
        Positioned(
          right: 0,
          child: IconButton(
            onPressed: () {},
            color: Colors.white,
            iconSize: 30.0,
            icon: const Icon(Icons.photo_camera_back),
          ),
        )
      ],
    );
  }

  void onPlayPressed() {
    setState(() {
      if (vidoeController!.value.isPlaying) {
        vidoeController!.pause();
      } else {
        vidoeController!.play();
      }
    });
  }

  void onReversePressed() {
    final currentPosition = vidoeController!.value.position;

    Duration position = const Duration();

    if (currentPosition.inSeconds > 3) {
      position = currentPosition - const Duration(seconds: 3);
    }
    vidoeController!.seekTo(position);
  }

  void onForwardPressed() {
    final maxPosition = vidoeController!.value.duration;
    final currentPosition = vidoeController!.value.position;

    Duration position = maxPosition;

    if ((maxPosition - const Duration(seconds: 3)).inSeconds >
        currentPosition.inSeconds) {
      position = currentPosition + const Duration(seconds: 3);
    }
    vidoeController!.seekTo(position);
  }
}

class _Controls extends StatelessWidget {
  final VoidCallback onPlayPressed;
  final VoidCallback onReversePressed;
  final VoidCallback onForwardPressed;
  final bool isPlaying;

  const _Controls({
    required this.onPlayPressed,
    required this.onReversePressed,
    required this.onForwardPressed,
    required this.isPlaying,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: Row(
        //crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          renderIconButton(
            onPressed: onReversePressed,
            iconData: Icons.rotate_left,
          ),
          renderIconButton(
            onPressed: onPlayPressed,
            iconData: isPlaying ? Icons.pause : Icons.play_arrow,
          ),
          renderIconButton(
            onPressed: onForwardPressed,
            iconData: Icons.rotate_right,
          ),
        ],
      ),
    );
  }

  Widget renderIconButton({
    required VoidCallback onPressed,
    required IconData iconData,
  }) {
    return IconButton(
      onPressed: onPressed,
      iconSize: 30.0,
      color: Colors.white,
      icon: Icon(iconData),
    );
  }
}
