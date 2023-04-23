import "package:calender_scheduler/component/custom_text_field.dart";
import "package:calender_scheduler/const/colors.dart";
import "package:calender_scheduler/database/drift_database.dart";
import "package:flutter/material.dart";
import "package:get_it/get_it.dart";

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
  int? selectedColorId;

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
                    FutureBuilder<List<CategoryColor>>(
                      future:
                          GetIt.I<LocalDatabase>().getCategoryColors(), // DI
                      builder: (context, snapshot) {
                        if (snapshot.hasData &&
                            selectedColorId == null &&
                            snapshot.data!.isNotEmpty) {
                          // 첫번째 색깔을 디폴트로 선택
                          selectedColorId = snapshot.data![0].id;
                        }
                        return _ColorPicker(
                          colors: snapshot.hasData ? snapshot.data! : [],
                          selectedColorId: selectedColorId!,
                          colorIdSetter: (int id) {
                            setState(() {
                              // 선택된 color의 id
                              selectedColorId = id;
                            });
                          },
                        );
                      },
                    ),
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

typedef ColorIdSetter = Function(int id);

class _ColorPicker extends StatelessWidget {
  const _ColorPicker({
    required this.colors,
    required this.selectedColorId,
    required this.colorIdSetter,
  });

  final List<CategoryColor> colors;
  final int selectedColorId;
  final ColorIdSetter colorIdSetter;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      // 줄바꿈 자동으로 되도록 Row 대신 Wrap
      spacing: 8, // 좌우 간격
      runSpacing: 10, // 상하 간격
      children: colors
          .map((e) => GestureDetector(
              onTap: () {
                colorIdSetter(e.id);
              },
              child: renderColor(e, selectedColorId == e.id)))
          .toList(),
    );
  }

  Widget renderColor(CategoryColor color, bool isSelected) {
    return Container(
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Color(int.parse('FF${color.hexCode}', radix: 16)),
          border: isSelected
              ? Border.all(
                  color: Colors.black,
                  width: 4,
                )
              : null),
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
