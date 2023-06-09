import "package:calender_scheduler/component/custom_text_field.dart";
import "package:calender_scheduler/const/colors.dart";
import "package:calender_scheduler/database/drift_database.dart";
import "package:drift/drift.dart"
    show Value; // Column이 겹치기 때문에 Value 만 drift 패키지에서 가져옴
import "package:flutter/material.dart";
import "package:get_it/get_it.dart";

class ScheduleBottomSheet extends StatefulWidget {
  const ScheduleBottomSheet({
    super.key,
    required this.selectedDate,
    this.scheduleId,
  });

  final DateTime selectedDate;
  final int? scheduleId; // ScheduleBottomSheet 클릭 시 보여주면서 id 셋팅

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
      child: FutureBuilder<Schedule>(
          future: widget.scheduleId == null
              ? null
              : GetIt.I<LocalDatabase>().getScheduleById(widget.scheduleId!),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text('스케줄을 불러올 수 없습니다.'),
              );
            }
            if (snapshot.connectionState != ConnectionState.none &&
                !snapshot.hasData) {
              // FutureBuilder 가 처음 실행됐고, 로딩중 일때
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasData && startTime == null) {
              // FutureBuilder 가 실행되고 값이 있는데, 단 한번도 startTime이 셋팅되지 않았을 때 값 셋팅해주기
              startTime = snapshot.data!.startTime;
              endTime = snapshot.data!.endTime;
              content = snapshot.data!.content;
              selectedColorId = snapshot.data!.colorId;
            }

            return SafeArea(
              child: Container(
                color: Colors.white,
                height: MediaQuery.of(context).size.height / 2 + bottomInset,
                child: Padding(
                  padding:
                      EdgeInsets.only(bottom: bottomInset), // 키보드 높이만큼 패딩 주기
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 8,
                      right: 8,
                      top: 16,
                    ),
                    child: Form(
                      // 모든 TextFormField 일괄적으로 관리하기
                      key: formKey,
                      autovalidateMode:
                          AutovalidateMode.always, // 입력시 실시간으로 자동 체크
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
                            startInitialValue: startTime?.toString() ?? '',
                            endInitialValue: endTime?.toString() ?? '',
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          _Content(
                            onSaved: (String? val) {
                              content = val;
                            },
                            initialValue: content ?? '',
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          FutureBuilder<List<CategoryColor>>(
                            future: GetIt.I<LocalDatabase>()
                                .getCategoryColors(), // DI
                            builder: (context, snapshot) {
                              if (snapshot.hasData &&
                                  selectedColorId == null &&
                                  snapshot.data!.isNotEmpty) {
                                // 첫번째 색깔을 디폴트로 선택
                                selectedColorId = snapshot.data![0].id;
                              }
                              return _ColorPicker(
                                colors: snapshot.hasData ? snapshot.data! : [],
                                selectedColorId: selectedColorId,
                                colorIdSetter: (int id) {
                                  setState(() {
                                    // 선택된 color의 id로 셋팅
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
            );
          }),
    );
  }

  void onSavePressed() async {
    // formKey는 생성했지만 아직 Form 위젯과 결합하지 않는 경우 (실제 발생은 안함)
    if (formKey.currentState == null) {
      return;
    }

    if (formKey.currentState!.validate()) {
      // 모든 TextFormField에서 null이 리턴 (에러 없음)
      formKey.currentState!.save(); // 각 CustomTextField의 onSaved 모두 실행

      if (widget.scheduleId == null) {
        // 새로 생성하는 경우 저장
        await GetIt.I<LocalDatabase>().createSchedule(
          SchedulesCompanion(
            date: Value(widget.selectedDate),
            startTime: Value(startTime!),
            endTime: Value(endTime!),
            content: Value(content!),
            colorId: Value(selectedColorId!),
          ),
        );
      } else {
        // 업데이트 하는 경우
        await GetIt.I<LocalDatabase>().updateScheduleById(
          widget.scheduleId!,
          SchedulesCompanion(
            date: Value(widget.selectedDate),
            startTime: Value(startTime!),
            endTime: Value(endTime!),
            content: Value(content!),
            colorId: Value(selectedColorId!),
          ),
        );
      }

      if (!mounted) return;
      Navigator.of(context).pop();
    } else {
      print('에러가 있습니다');
    }
  }
}

class _Content extends StatelessWidget {
  const _Content({
    required this.onSaved,
    required this.initialValue,
  });

  final FormFieldSetter<String> onSaved;
  final String initialValue;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: CustomTextField(
        label: '내용',
        isTime: false,
        onSaved: onSaved,
        initialValue: initialValue,
      ),
    );
  }
}

class _Time extends StatelessWidget {
  const _Time({
    required this.onStartSaved,
    required this.onEndSaved,
    required this.startInitialValue,
    required this.endInitialValue,
  });

  final FormFieldSetter<String> onStartSaved;
  final FormFieldSetter<String> onEndSaved;
  final String startInitialValue;
  final String endInitialValue;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomTextField(
            label: '시작시간',
            isTime: true,
            onSaved: onStartSaved,
            initialValue: startInitialValue,
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
            initialValue: endInitialValue,
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
  final int? selectedColorId;
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
