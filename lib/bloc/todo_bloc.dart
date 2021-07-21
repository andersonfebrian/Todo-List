import 'dart:async';

import 'package:todo_list/bloc/shared/bloc.dart';
import 'package:todo_list/bloc/todo_event.dart';
import 'package:todo_list/models/todo.dart';
import 'package:todo_list/repository/todo_repository.dart';

class TodoBloc implements Bloc {
  List<Todo> todos = [];

  final _todoRepository = TodoRepository();

  final _streamController = StreamController<List<Todo>>();
  Stream<List<Todo>> get stream => _streamController.stream;
  Sink<List<Todo>> get _streamSink => _streamController.sink;

  final _streamEventController = StreamController<TodoEvent>();
  Sink<TodoEvent> get todoEventSink => _streamEventController.sink;

  TodoBloc() {
    _streamEventController.stream.listen((event) {
      _mapEventToState(event);
    });
  }

  _mapEventToState(TodoEvent event) {
    if (event is TodoAdded) {
      _mapTodoAddedToState(event);
    }
    if (event is TodoUpdated) {
      _mapTodoUpdatedToState(event);
    }
    if (event is TodoDeleted) {
      _mapTodoDeletedToState(event);
    }
    if (event is TodoLoaded) {
      _mapTodoLoadedToState(event);
    }
  }

  _mapTodoAddedToState(TodoAdded event) async {
    await _todoRepository.insert(event.todo);
    todos = await _todoRepository.fetchAll();
    _streamSink.add(todos);
  }

  _mapTodoUpdatedToState(TodoUpdated event) async {
    await _todoRepository.update(event.todo);
    todos = await _todoRepository.fetchAll();
    _streamSink.add(todos);
  }

  _mapTodoDeletedToState(TodoDeleted event) async {
    await _todoRepository.delete(event.todo);

    todos = await _todoRepository.fetchAll();

    _streamSink.add(todos);
  }

  _mapTodoLoadedToState(TodoLoaded event) async {
    _streamSink.add(await _todoRepository.fetchAll());
  }

  @override
  void dispose() {
    _streamController.close();
    _streamEventController.close();
  }
}
