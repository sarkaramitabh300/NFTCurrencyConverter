import 'package:currency_calculator/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'CurvedNavBar.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: BottomNavBar(),
    );
  }
}
