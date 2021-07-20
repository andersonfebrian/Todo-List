
import 'dart:html';

import 'package:todo_list/models/todo.dart';

abstract class TodoState { 
  const TodoState();

  @override
  List<Object> get props => [];
}

class TodoLoading extends TodoState {}
class TodoLoadFailure extends TodoState{}

class TodoLoadSuccess extends TodoState {
  final List<Todo> todos;

  const TodoLoadSuccess(this.todos);

  @override
  List<Object> get props => [todos];
}