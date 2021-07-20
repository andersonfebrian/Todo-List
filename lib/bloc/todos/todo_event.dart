import 'package:todo_list/models/todo.dart';

abstract class TodoEvent {
  @override
  List<Object> get prop => [];
}

class TodoLoaded extends TodoEvent {}

class TodoAdded extends TodoEvent {
  final Todo todo;
  TodoAdded(this.todo);

  @override
  List<Object> get prop => [todo];
}

class TodoUpdated extends TodoEvent {
  final Todo todo;
  TodoUpdated(this.todo);

  @override
  List<Object> get prop => [todo];
}

class TodoDeleted extends TodoEvent {
  final Todo todo;
  TodoDeleted(this.todo);

  @override
  List<Object> get prop => [todo];
}
