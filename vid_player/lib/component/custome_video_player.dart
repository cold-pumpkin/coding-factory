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
    return VideoPlayer(vidoeController!);
  }
}
