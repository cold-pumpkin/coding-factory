import 'dart:math';

import 'package:flutter/material.dart';
import 'package:random_number/component/number_row.dart';
import 'package:random_number/constant/color.dart';
import 'package:random_number/screen/setting_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int maxnumber = 1000;
  List<int> randomNumbers = [
    123,
    456,
    789,
  ];

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
              _Header(
                onPressed: onSettingsPop,
              ),
              _Body(randomNumbers: randomNumbers),
              _Footer(
                onPressed: onRandomNumberGenerator,
              )
            ],
          ),
        ),
      ),
    );
  }

  void onRandomNumberGenerator() {
    final rand = Random();
    Set<int> newNumbers = {};
    while (newNumbers.length != 3) {
      newNumbers.add(rand.nextInt(maxnumber));
    }
    setState(() {
      randomNumbers = newNumbers.toList();
    });
  }

  void onSettingsPop() async {
    final result = await Navigator.of(context).push<int>(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return SettingsScreen(
            maxNumber: maxnumber,
          );
        },
      ),
    ); // 화면 이동 후 돌아오면서 결과값 받음 (async - await)
    // int? 타입(null 가능성)이므로 null check 필요

    if (result != null) {
      setState(() {
        maxnumber = result;
      });
    }
  }
}

class _Body extends StatelessWidget {
  const _Body({
    required this.randomNumbers,
  });

  final List<int> randomNumbers;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: randomNumbers
              .asMap()
              .entries
              .map(
                (x) => Padding(
                  padding: EdgeInsets.only(bottom: x.key == 2 ? 0 : 16),
                  child: NumberRow(
                    maxNumber: x.value,
                  ),
                ),
              )
              .toList()),
    );
  }
}

class _Header extends StatelessWidget {
  final VoidCallback onPressed;

  const _Header({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          '랜덤숫자 생성기',
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.w700,
          ),
        ),
        IconButton(
          onPressed: onPressed,
          icon: const Icon(
            Icons.settings,
            color: RED_COLOR,
          ),
        )
      ],
    );
  }
}

class _Footer extends StatelessWidget {
  final VoidCallback onPressed;
  const _Footer({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, // 양끝까지 넒히기
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: RED_COLOR,
        ),
        onPressed: onPressed,
        child: const Text('생성하기!'),
      ),
    );
  }
}
