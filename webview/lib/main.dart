import 'package:flutter/material.dart';

import 'screen/home_screen.dart';

void main() {
  // Flutter가 앱을 실행할 준비가 될 때까지 대기
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MaterialApp(
    home: HomeScreen(),
  ));
}
