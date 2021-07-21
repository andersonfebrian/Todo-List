import 'package:flutter/material.dart';
import 'package:todo_list/bloc/todo_bloc.dart';
import 'package:todo_list/bloc/todo_event.dart';
import 'package:todo_list/ui/todo_ui.dart';

class TodoAppHome extends StatefulWidget {
  const TodoAppHome({Key? key}) : super(key: key);

  @override
  _TodoAppHomeState createState() => _TodoAppHomeState();
}

class _TodoAppHomeState extends State<TodoAppHome> {
  final _bloc = TodoBloc();

  @override
  void initState() {
    _bloc.todoEventSink.add(TodoLoaded());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TodoUI(_bloc).mainTodoUI(context),
    );
  }
}
