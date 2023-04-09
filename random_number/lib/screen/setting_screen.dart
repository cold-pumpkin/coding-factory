import 'package:flutter/material.dart';
import 'package:random_number/constant/color.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  double maxNumber = 10000;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PRIMARY_COLOR,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Row(
                  children: maxNumber
                      .toInt()
                      .toString()
                      .split('')
                      .map(
                        (e) => Image.asset(
                          'asset/image/$e.png',
                          width: 50,
                          height: 70,
                        ),
                      )
                      .toList(),
                ),
              ),
              Slider(
                  value: maxNumber,
                  min: 1000,
                  max: 100000,
                  onChanged: (double val) {
                    setState(() {
                      maxNumber = val;
                    });
                  }),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context)
                      .pop(maxNumber.toInt()); // 데이터 전달하면서 뒤로가기
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: RED_COLOR,
                ),
                child: const Text('저장!'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
