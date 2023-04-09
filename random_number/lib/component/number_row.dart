import 'package:flutter/widgets.dart';

class NumberRow extends StatelessWidget {
  const NumberRow({
    super.key,
    required this.maxNumber,
  });

  final int maxNumber;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: maxNumber
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
    );
  }
}
