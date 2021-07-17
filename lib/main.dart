import 'package:flutter/material.dart';
import 'package:todo_list/home.dart';
import 'loading.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(TodoApp());
}

class TodoApp extends StatefulWidget {
  @override
  _TodoAppState createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> {

  initializeFirebase() async {
    await Firebase.initializeApp().whenComplete(() => print("init firebase"));
  }

  @override
  void initState() {
    super.initState();
    initializeFirebase();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TodoAppHome(),
      routes: {
        '/home' : (context) => TodoAppHome()
      },
    );
  }
}
