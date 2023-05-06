import 'dart:io';

import 'package:calender_scheduler/model/schedule_with_color.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';

import '../model/category_color.dart';
import '../model/schedule.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'drift_database.g.dart';

@DriftDatabase(
  tables: [
    Schedules,
    CategoryColors,
  ],
)
class LocalDatabase extends _$LocalDatabase {
  LocalDatabase() : super(_openConnection());

  Future<int> createSchedule(SchedulesCompanion data) =>
      into(schedules).insert(data);

  Future<int> createCategoryColor(CategoryColorsCompanion data) =>
      into(categoryColors).insert(data);

  Future<List<CategoryColor>> getCategoryColors() =>
      select(categoryColors).get();

  // 스케쥴이 반영되면 조회 목록에도 반영되도록
  Stream<List<ScheduleWithColor>> watchSchedules(DateTime date) {
    //=> (select(schedules)..where((tbl) => tbl.date.equals(date))).watch();
    // .. : where 가 적용은 되지만, 그 대상이 그대로 리턴됨

    final query = select(schedules).join([
      innerJoin(categoryColors, categoryColors.id.equalsExp(schedules.colorId))
    ]);
    query.where(schedules.date.equals(date)); // 어떤 테이블에 조건을 걸지 명시
    query.orderBy([
      OrderingTerm.asc(
        schedules.startTime,
      )
    ]);
    return query.watch().map(
          (rows) => rows
              .map(
                (row) => ScheduleWithColor(
                  schedule: row.readTable(schedules),
                  categoryColor: row.readTable(categoryColors),
                ),
              )
              .toList(),
        );
  }

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    // path_provider 를 통해 앱의 저장위치 가져오기
    final dbFolder = await getApplicationDocumentsDirectory();

    // 테이블 정보 담을 파일 생성
    final file = File(p.join(dbFolder.path, 'db.splite'));

    return NativeDatabase(file);
  });
}
