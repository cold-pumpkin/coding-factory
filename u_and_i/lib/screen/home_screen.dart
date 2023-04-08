import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[100], // default : 500
      body: SafeArea(
        bottom: false,
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: const [
              _TopPart(),
              _BottomPart(),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomPart extends StatelessWidget {
  const _BottomPart();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Image.asset(
        'asset/image/middle_image.png',
      ),
    );
  }
}

class _TopPart extends StatefulWidget {
  const _TopPart();

  @override
  State<_TopPart> createState() => _TopPartState();
}

class _TopPartState extends State<_TopPart> {
  DateTime selectedDate = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Text(
            'U&I',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'parisienne',
              fontSize: 80,
            ),
          ),
          Column(
            children: [
              const Text(
                '우리 처음 만난날',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'sunflower',
                  fontSize: 30,
                ),
              ),
              Text(
                '${selectedDate.year}.${selectedDate.month}.${selectedDate.day}',
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'sunflower',
                  fontSize: 20,
                ),
              ),
            ],
          ),
          IconButton(
            iconSize: 60,
            onPressed: () {
              showCupertinoDialog(
                context: context,
                barrierDismissible: true, // 밖 클릭하면 닫힘
                builder: (BuildContext context) {
                  return Align(
                    // 어디에 정렬할지 모르면 최대공간을 차지하기 때문에 Align으로 정렬 필요
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      color: Colors.white,
                      height: 300,
                      child: CupertinoDatePicker(
                        mode: CupertinoDatePickerMode.date,
                        initialDateTime: selectedDate,
                        maximumDate: DateTime(
                          DateTime.now().year,
                          DateTime.now().month,
                          DateTime.now().day,
                        ),
                        onDateTimeChanged: (DateTime date) {
                          setState(() {
                            selectedDate = date;
                          });
                        },
                      ),
                    ),
                  );
                },
              );
            },
            icon: const Icon(Icons.favorite),
            color: Colors.red,
          ),
          Text(
            'D+${DateTime(
                  now.year,
                  now.month,
                  now.day,
                ).difference(selectedDate).inDays + 1}',
            style: const TextStyle(
                color: Colors.white,
                fontFamily: 'sunflower',
                fontSize: 50,
                fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
