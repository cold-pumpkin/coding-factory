import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Timer? timer;
  PageController controller = PageController(
    initialPage: 0,
  ); // 페이지뷰 조정을 위한 컨트롤러

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      int currentPage = controller.page!.toInt(); // 반올림
      int nextPage = currentPage + 1;

      if (nextPage > 4) {
        nextPage = 0;
      }

      controller.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 400),
        curve: Curves.linear,
      );
    });
  }

  @override
  void dispose() {
    // 메모리 보호를 위해 삭제
    controller.dispose();
    if (timer != null) {
      timer!.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark); // 상태바 색깔

    return Scaffold(
      body: PageView(
        controller: controller,
        children: [1, 2, 3, 4, 5]
            .map((e) => Image.asset(
                  'assets/images/image_$e.jpeg',
                  fit: BoxFit.cover,
                ))
            .toList(),
      ),
    );
  }
}
