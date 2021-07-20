import 'package:flutter/material.dart';
import 'package:todo_list/ui/todo_ui.dart';

class TodoAppHome extends StatefulWidget {
  const TodoAppHome({Key? key}) : super(key: key);

  @override
  _TodoAppHomeState createState() => _TodoAppHomeState();
}

class _TodoAppHomeState extends State<TodoAppHome> {
  @override
  Widget build(BuildContext context) {
    return Text("");
    //return TodoUI().mainTodoUI(context);
  }
}
