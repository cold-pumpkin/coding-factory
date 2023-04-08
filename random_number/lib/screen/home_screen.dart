import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('랜덤숫자 생성기'),
                IconButton(
                  onPressed: null,
                  icon: Icon(
                    Icons.settings,
                  ),
                )
              ],
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text('123'),
                  Text('456'),
                  Text('789'),
                ],
              ),
            ),
            SizedBox(
              width: double.infinity, // 양끝까지 넒히기
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('생성하기!'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
