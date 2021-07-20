import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list/bloc/todos/todo_event.dart';
import 'package:todo_list/bloc/todos/todo_state.dart';
import 'package:todo_list/repository/todo_repository.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {

  final TodoRepository _todoRepository;
  StreamSubscription? _streamSubscription;

  TodoBloc(this._todoRepository) : super(TodoLoading());

  @override
  Stream<TodoState> mapEventToState(TodoEvent event) async* {
    if(event is TodoLoaded) {
      yield* _mapTodoLoadedToState();
    }
    
    if(event is TodoAdded) {
      yield* _mapTodoAddedToState(event);
    }

    if(event is TodoUpdated) {
      yield* _mapTodoUpdatedToState(event);
    }

    if(event is TodoDeleted) {
      yield* _mapTodoDeletedToState(event); 
    }
  }

  Stream<TodoState> _mapTodoLoadedToState() async* {
    _streamSubscription?.cancel();
    _streamSubscription = _todoRepository.fetch().listen((todos) {
      add(TodoUpdated(todos));
    });
  }

  Stream<TodoState> _mapTodoAddedToState(TodoAdded event) async* {
    _todoRepository.insert(event.todo);
  }

  Stream<TodoState> _mapTodoUpdatedToState(TodoUpdated event) async* {
    _todoRepository.update(event.todo);
  }

  Stream<TodoState> _mapTodoDeletedToState(TodoDeleted event) async* {
    _todoRepository.delete(event.todo);
  }

  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    return super.close();
  }
}