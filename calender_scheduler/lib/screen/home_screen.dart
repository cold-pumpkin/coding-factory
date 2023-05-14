import 'package:calender_scheduler/component/calender.dart';
import 'package:calender_scheduler/component/schedule_bottom_sheet.dart';
import 'package:calender_scheduler/const/colors.dart';
import 'package:calender_scheduler/database/drift_database.dart';
import 'package:calender_scheduler/model/schedule_with_color.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../component/schedule_card.dart';
import '../component/today_banner.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime selectedDay = DateTime.utc(
    // UTC 기준 날짜 생성
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
  DateTime focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: renderFloatingActionButton(),
      body: SafeArea(
        child: Column(
          children: [
            Calender(
              selectedDay: selectedDay,
              focusedDay: focusedDay,
              onDaySelected: onDaySelected,
            ),
            const SizedBox(
              height: 8,
            ),
            TodayBanner(
              selectedDay: selectedDay,
            ),
            const SizedBox(
              height: 8,
            ),
            _ScheduleList(
              selectedDay: selectedDay,
            ),
          ],
        ),
      ),
    );
  }

  FloatingActionButton renderFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true, // 화면 중간 이상으로 bottom sheet가 올라올 수 있도록
          builder: (_) {
            return ScheduleBottomSheet(
              selectedDate: selectedDay,
            );
          },
        );
      },
      backgroundColor: PRIMARY_COLOR,
      child: const Icon(
        Icons.add,
      ),
    );
  }

  onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      this.selectedDay = selectedDay;
      this.focusedDay = selectedDay;
    });
  }
}

class _ScheduleList extends StatelessWidget {
  const _ScheduleList({
    required this.selectedDay,
  });

  final DateTime selectedDay;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: StreamBuilder<List<ScheduleWithColor>>(
            stream: GetIt.I<LocalDatabase>().watchSchedules(selectedDay),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasData && snapshot.data!.isEmpty) {
                return const Center(
                  child: Text('스케줄이 없습니다.'),
                );
              }
              return ListView.separated(
                itemCount: snapshot.data!.length,
                separatorBuilder: (context, index) {
                  return const SizedBox(
                    height: 8,
                  );
                },
                itemBuilder: (context, index) {
                  final scheduleWithColor = snapshot.data![index];

                  return Dismissible(
                    key: ObjectKey(scheduleWithColor.schedule.id),
                    direction: DismissDirection.endToStart, // 스와이프 방향
                    onDismissed: (DismissDirection direction) {
                      GetIt.I<LocalDatabase>()
                          .removeSchedule(scheduleWithColor.schedule.id);
                    },
                    child: GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled:
                              true, // 화면 중간 이상으로 bottom sheet가 올라올 수 있도록
                          builder: (_) {
                            return ScheduleBottomSheet(
                              selectedDate: selectedDay,
                              scheduleId: scheduleWithColor.schedule.id,
                            );
                          },
                        );
                      },
                      child: ScheduleCard(
                        startTime: scheduleWithColor.schedule.startTime,
                        endTime: scheduleWithColor.schedule.endTime,
                        content: scheduleWithColor.schedule.content,
                        color: Color(
                          int.parse(
                            'FF${scheduleWithColor.categoryColor.hexCode}',
                            radix: 16,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
      ),
    );
  }
}
