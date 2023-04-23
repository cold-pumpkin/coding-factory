import "package:calender_scheduler/component/custom_text_field.dart";
import "package:calender_scheduler/const/colors.dart";
import "package:flutter/material.dart";

class ScheduleBottomSheet extends StatefulWidget {
  const ScheduleBottomSheet({super.key});

  @override
  State<ScheduleBottomSheet> createState() => _ScheduleBottomSheetState();
}

class _ScheduleBottomSheetState extends State<ScheduleBottomSheet> {
  final GlobalKey<FormState> formKey = GlobalKey();

  int? startTime;
  int? endTime;
  String? content;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom; // 키보드 올라오는 높이

    return GestureDetector(
      onTap: () {
        // bottom sheet를 탭하면 키보드가 닫히도록
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: SafeArea(
        child: Container(
          color: Colors.white,
          height: MediaQuery.of(context).size.height / 2 + bottomInset,
          child: Padding(
            padding: EdgeInsets.only(bottom: bottomInset), // 키보드 높이만큼 패딩 주기
            child: Padding(
              padding: const EdgeInsets.only(
                left: 8,
                right: 8,
                top: 16,
              ),
              child: Form(
                // 모든 TextFormField 일괄적으로 관리하기
                key: formKey,
                autovalidateMode: AutovalidateMode.always, // 입력시 실시간으로 자동 체크
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Time(
                      onStartSaved: (String? val) {
                        startTime = int.parse(val!);
                      },
                      onEndSaved: (String? val) {
                        endTime = int.parse(val!);
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    _Content(
                      onSaved: (String? val) {
                        content = val;
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    const _ColorPicker(),
                    const SizedBox(
                      height: 8,
                    ),
                    _SaveButton(
                      onPressed: onSavePressed,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onSavePressed() {
    // formKey는 생성했지만 아직 Form 위젯과 결합하지 않는 경우 (실제 발생은 안함)
    if (formKey.currentState == null) {
      return;
    }

    if (formKey.currentState!.validate()) {
      // 모든 TextFormField에서 null이 리턴 (에러 없음)
      print('에러가 없습니다');
      formKey.currentState!.save(); // 각 CustomTextField의 onSaved 모두 실행
    } else {
      print('에러가 있습니다');
    }
  }
}

class _Content extends StatelessWidget {
  const _Content({
    required this.onSaved,
  });

  final FormFieldSetter<String> onSaved;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: CustomTextField(
        label: '내용',
        isTime: false,
        onSaved: onSaved,
      ),
    );
  }
}

class _Time extends StatelessWidget {
  const _Time({
    required this.onStartSaved,
    required this.onEndSaved,
  });

  final FormFieldSetter<String> onStartSaved;
  final FormFieldSetter<String> onEndSaved;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomTextField(
            label: '시작시간',
            isTime: true,
            onSaved: onStartSaved,
          ),
        ),
        const SizedBox(
          width: 16,
        ),
        Expanded(
          child: CustomTextField(
            label: '마감시간',
            isTime: true,
            onSaved: onEndSaved,
          ),
        ),
      ],
    );
  }
}

class _ColorPicker extends StatelessWidget {
  const _ColorPicker();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      // 줄바꿈 자동으로 되도록 Row 대신 Wrap
      spacing: 8, // 좌우 간격
      runSpacing: 10, // 상하 간격
      children: [
        renderColor(Colors.red),
        renderColor(Colors.orange),
        renderColor(Colors.yellow),
        renderColor(Colors.green),
        renderColor(Colors.blue),
        renderColor(Colors.indigo),
        renderColor(Colors.purple),
      ],
    );
  }

  Widget renderColor(Color color) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
      width: 32,
      height: 32,
    );
  }
}

class _SaveButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _SaveButton({
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: PRIMARY_COLOR,
            ),
            child: const Text('저장'),
          ),
        ),
      ],
    );
  }
}
