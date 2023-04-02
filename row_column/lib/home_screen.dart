import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          bottom: false,
          child: Container(
            color: Colors.black,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  flex: 2,
                  child: Container(
                    color: Colors.red,
                    width: 50,
                    height: 50,
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    color: Colors.orange,
                    width: 50,
                    height: 50,
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.yellow,
                    width: 50,
                    height: 50,
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.green,
                    width: 50,
                    height: 50,
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
