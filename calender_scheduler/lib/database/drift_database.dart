import 'dart:io';

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
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    // path_provider 를 통해 앱의 저장위치 가져오기
    final dbFolder = await getApplicationDocumentsDirectory();

    // 테이블 정보 담을 파일
    final file = File(p.join(dbFolder.path, 'db.splite'));

    return NativeDatabase(file);
  });
}
