import 'package:flutter/material.dart';
import 'package:todo_list/home.dart';
import 'loading.dart';

void main() {
  runApp(TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TodoAppHome(),
      routes: {
        '/loading' : (context) => LoadingPage(),
        '/home' : (context) => TodoAppHome()
      },
    );
  }
}