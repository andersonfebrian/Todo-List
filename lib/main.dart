import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list/bloc/todos/todo_bloc.dart';
import 'package:todo_list/home.dart';
import 'package:todo_list/repository/todo_repository.dart';
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

  @override
  void initState() {
    super.initState();
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

class Todos extends StatelessWidget {
  const Todos({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TodoBloc>(
      create: (context) {
        return TodoBloc(TodoRepository());
      },
      child: MaterialApp(

      ),
    );
  }
}
