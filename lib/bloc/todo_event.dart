import 'package:todo_list/models/todo.dart';

abstract class TodoEvent{}

class TodoAdded implements TodoEvent {
  final Todo todo;

  TodoAdded(this.todo);
}

class TodoUpdated implements TodoEvent {
  final Todo todo;

  TodoUpdated(this.todo);
}

class TodoDeleted implements TodoEvent {
  final Todo todo;

  TodoDeleted(this.todo);
}

class TodoLoaded implements TodoEvent {}