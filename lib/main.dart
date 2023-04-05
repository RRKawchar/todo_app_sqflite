import 'package:flutter/material.dart';
import 'package:todo_app_sqflite/screen/home_screen.dart';

void main(){

  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todo app',
      theme: ThemeData(
        primaryColor: Colors.orangeAccent,
        primarySwatch: Colors.blue
      ),
     home: const HomeScreen(),
    );
  }
}
