part of 'todo_bloc.dart';

@immutable
abstract class TodoEvent {
  const TodoEvent();
}

class FetchTodos extends TodoEvent {
  
  const FetchTodos();
}

class AddTodo extends TodoEvent {
  final String body;
  
  const AddTodo(this.body);
}

class UpdateTodo extends TodoEvent {

  final Todo todo;

  const UpdateTodo(this.todo);
}

class DeleteTodo extends TodoEvent {

  final Todo todo;

  const DeleteTodo(this.todo);
}