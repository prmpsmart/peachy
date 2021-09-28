import 'package:flutter/material.dart';
import 'package:peachy/screens/home.dart';
import 'constants.dart';

void main() {
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: materialColor('#d85461'),
        accentColor: Color(0xFFFEF9EB),
      ),
      home: Home(),
    );
  }
}
