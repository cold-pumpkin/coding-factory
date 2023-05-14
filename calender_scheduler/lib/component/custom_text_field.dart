import 'package:calender_scheduler/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.label,
    required this.isTime,
    required this.onSaved,
    required this.initialValue,
  });

  final String label;
  final bool isTime;
  final FormFieldSetter<String> onSaved;
  final String initialValue;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
              color: PRIMARY_COLOR, fontWeight: FontWeight.w600),
        ),
        isTime ? renderTextField() : Expanded(child: renderTextField()),
      ],
    );
  }

  TextFormField renderTextField() {
    return TextFormField(
      onSaved: onSaved,
      validator: (String? val) {
        if (val == null || val.isEmpty) {
          return '값을 입력해주세요';
        }
        if (isTime) {
          int time = int.parse(val);
          if (time < 0) {
            return '0 이상의 숫자를 입력해주세요.';
          }
          if (time > 24) {
            return '24 이하의 숫자를 입력해주세요.';
          }
        }

        return null;
      },
      cursorColor: Colors.grey,
      keyboardType: isTime ? TextInputType.number : TextInputType.multiline,
      maxLines: isTime ? 1 : null,
      maxLength: 500,
      expands: !isTime, // 최대한 늘리기
      initialValue: initialValue,
      inputFormatters: isTime
          ? [
              FilteringTextInputFormatter.digitsOnly, // 숫자만 입력 가능
            ]
          : [],
      decoration: InputDecoration(
        border: InputBorder.none,
        filled: true,
        fillColor: Colors.grey[300],
        suffixText: isTime ? '시' : null,
      ),
    );
  }
}
