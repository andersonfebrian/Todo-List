
import 'dart:async';

import 'package:todo_list/bloc/shared/bloc.dart';
import 'package:todo_list/bloc/todo_event.dart';
import 'package:todo_list/models/todo.dart';
import 'package:todo_list/repository/todo_repository.dart';

class TodoBloc implements Bloc {
  final _todoRepository = TodoRepository();

  final _streamController = StreamController<List<Todo>>();
  Stream<List<Todo>> get _stream => _streamController.stream;
  Sink<List<Todo>> get streamSink => _streamController.sink;

  final _streamEventController = StreamController<TodoEvent>();
  Sink<TodoEvent> get todoEventSink => _streamEventController.sink;

  @override
  void dispose() {
    _streamController.close();
    _streamEventController.close();
  }
}