import 'dart:async';
import 'package:todo_list/models/todo.dart';
import 'package:todo_list/repository/todo_repository.dart';

class TodoService {
  final _todoRepository = TodoRepository();

  Future<bool> insertTodo(Todo todo) async => await _todoRepository.insert(todo);

  Future<bool> updateTodo(Todo todo) async => await _todoRepository.update(todo);

  Future<bool> deleteTodo(Todo todo) async => await _todoRepository.delete(todo);
}
