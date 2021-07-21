import 'package:flutter/material.dart';
import 'package:todo_list/bloc/todo_bloc.dart';
import 'package:todo_list/ui/todo_ui.dart';

class TodoAppHome extends StatefulWidget {

  final TodoBloc _bloc;

  const TodoAppHome(this._bloc, {Key? key}) : super(key: key);

  @override
  _TodoAppHomeState createState() => _TodoAppHomeState(_bloc);
}

class _TodoAppHomeState extends State<TodoAppHome> {

  final TodoBloc _bloc;

  _TodoAppHomeState(this._bloc);

  @override
  Widget build(BuildContext context) {
    return TodoUI(_bloc).mainTodoUI(context);
  }
}
