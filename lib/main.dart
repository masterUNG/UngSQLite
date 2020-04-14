import 'package:flutter/material.dart';
import 'package:ungsqlite/widget/learn_sqlite.dart';

// Full Format
// void main() {
//   runApp(MyApp());
// }

// Less Format
main()=>runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LearnSqlite(),
    );
  }
}
