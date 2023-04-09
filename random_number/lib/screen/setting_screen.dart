import 'package:flutter/material.dart';
import 'package:random_number/component/number_row.dart';
import 'package:random_number/constant/color.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key, required this.maxNumber});

  final int maxNumber;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  double maxNumber = 10000;

  @override
  void initState() {
    super.initState();
    maxNumber = widget.maxNumber.toDouble();
  }

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
            children: [
              _Body(maxNumber: maxNumber),
              _Footer(
                maxNumber: maxNumber,
                onSliderChnaged: onSliderChanged,
                onButtonPressed: onButtonPressed,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onSliderChanged(double val) {
    setState(() {
      maxNumber = val;
    });
  }

  void onButtonPressed() {
    Navigator.of(context).pop(maxNumber.toInt()); // 데이터 전달하면서 뒤로가기
  }
}

class _Body extends StatelessWidget {
  const _Body({
    required this.maxNumber,
  });

  final double maxNumber;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: NumberRow(maxNumber: maxNumber.toInt()),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({
    required this.maxNumber,
    required this.onSliderChnaged,
    required this.onButtonPressed,
  });

  final double maxNumber;
  final ValueChanged<double>? onSliderChnaged;
  final VoidCallback onButtonPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Slider(
          value: maxNumber,
          min: 1000,
          max: 100000,
          onChanged: onSliderChnaged,
        ),
        ElevatedButton(
          onPressed: onButtonPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: RED_COLOR,
          ),
          child: const Text('저장!'),
        )
      ],
    );
  }
}
