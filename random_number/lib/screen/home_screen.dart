import 'package:flutter/material.dart';
import 'package:random_number/constant/color.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PRIMARY_COLOR,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    '랜덤숫자 생성기',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  IconButton(
                    onPressed: null,
                    icon: Icon(
                      Icons.settings,
                      color: RED_COLOR,
                    ),
                  )
                ],
              ),
              Expanded(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      123,
                      456,
                      789,
                    ]
                        .asMap()
                        .entries
                        .map(
                          (x) => Padding(
                            padding:
                                EdgeInsets.only(bottom: x.key == 2 ? 0 : 16),
                            child: Row(
                              children: x.value
                                  .toString()
                                  .split('')
                                  .map(
                                    (e) => Image.asset(
                                      'asset/image/$e.png',
                                      height: 70,
                                      width: 50,
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        )
                        .toList()),
              ),
              SizedBox(
                width: double.infinity, // 양끝까지 넒히기
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: RED_COLOR,
                  ),
                  onPressed: () {},
                  child: const Text('생성하기!'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
