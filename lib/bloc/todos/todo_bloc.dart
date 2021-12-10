import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:todo_list/models/todo.dart';
import 'package:todo_list/repository/todo_repository.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {

  final TodoRepository _todoRepository;

  TodoBloc(this._todoRepository) : super(TodoInitial());

  @override
  Stream<TodoState> mapEventToState(
    TodoEvent event,
  ) async* {
    if(event is FetchTodos) {
      yield* _mapFetchTodoToState();
    }

    if(event is AddTodo) {
      yield* _mapAddTodoToState(event);
    }

    if(event is UpdateTodo) {
      yield* _mapUpdateTodoToState(event);
    }

    if(event is DeleteTodo) {
      yield* _mapDeleteTodoToState(event);
    }
  }

  Stream<TodoState> _mapFetchTodoToState() async* {
    try {
      yield TodoLoading();
      final _todos = await _todoRepository.fetchTodos();
      yield TodoLoaded(_todos);
    } on Exception {yield TodoError("");}
  }

  Stream<TodoState> _mapAddTodoToState(AddTodo event) async* {
    try {
      await _todoRepository.insertTodo(Todo(event.body));

      final _todos = await _todoRepository.fetchTodos();
      yield TodoLoaded(_todos);
    } on Exception {
      yield TodoError("Something Went Wrong. Please try again later.");
    }
  }

  Stream<TodoState> _mapUpdateTodoToState(UpdateTodo event) async* {
    try {
      await _todoRepository.updateTodo(event.todo);
      final _todos = await _todoRepository.fetchTodos();
      yield(TodoLoaded(_todos));
    } on Exception {
      yield TodoError("Something Went Wrong. Please try again later.");
    }
  }

  Stream<TodoState> _mapDeleteTodoToState(DeleteTodo event) async* {
    try {
      await _todoRepository.deleteTodo(event.todo);
      final _todos = await _todoRepository.fetchTodos();
      yield(TodoLoaded(_todos));
    } on Exception {
      yield TodoError("Something Went Wrong. Please try again later.");
    }
  }
}
