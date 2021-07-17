import 'dart:async';
import 'package:todo_list/models/todo.dart';
import 'package:todo_list/services/todo_service.dart';

class TodoBLOC {
  
  final StreamController<List<Todo>> _controller = StreamController();

  TodoBLOC() {
      fetch();
    _controller.onListen = () {
    };
  }

  Stream<List<Todo>> fetch() async* {

  }

  Stream<List<Todo>> get stream => _controller.stream;

  dispose() {
    _controller.close();
  }
}