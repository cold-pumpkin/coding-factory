import 'package:calender_scheduler/database/drift_database.dart';
import 'package:calender_scheduler/screen/home_screen.dart';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

const DEFAULT_COLORS = [
  'F44336', // RED
  'FF9800', // ORANGE
  'FFEB3B', // YELLOW
  'FCAF50', // GREEN
  '2196F3', // BLUE
  '3F51B5', // NAVY
  '9C27B0', // PURPLE
];
void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // 프레임워크가 준비될 때 까지 대기
  await initializeDateFormatting();

  final database = LocalDatabase();
  final colors = await database.getCategoryColors();

  if (colors.isEmpty) {
    for (String hexCode in DEFAULT_COLORS) {
      await database.createCategoryColor(
        CategoryColorsCompanion(
          hexCode: Value(hexCode),
        ),
      );
    }
  }

  print(await database.getCategoryColors());

  runApp(
    MaterialApp(
      theme: ThemeData(
        fontFamily: 'NotoSans',
      ),
      home: const HomeScreen(),
    ),
  );
}
