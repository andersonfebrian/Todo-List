import 'package:flutter/material.dart';
import 'package:todo_list/bloc/todo_bloc.dart';
import 'package:todo_list/bloc/todo_event.dart';
import 'package:todo_list/home.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().whenComplete(() => print("init firebase"));
  runApp(TodoApp());
}

class TodoApp extends StatefulWidget {
  @override
  _TodoAppState createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> {

  final _bloc = TodoBloc();

  @override
  void initState() {
    _bloc.todoEventSink.add(TodoLoaded());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TodoAppHome(_bloc),
      routes: {
        '/home' : (context) => TodoAppHome(_bloc)
      },
    );
  }
}
