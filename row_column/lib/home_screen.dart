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
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  color: Colors.red,
                  width: 50,
                  height: 50,
                ),
                Container(
                  color: Colors.orange,
                  width: 50,
                  height: 50,
                ),
                Container(
                  color: Colors.yellow,
                  width: 50,
                  height: 50,
                ),
                Container(
                  color: Colors.green,
                  width: 50,
                  height: 50,
                ),
              ],
            ),
          )),
    );
  }
}
