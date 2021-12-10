import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_list/models/todo.dart';

abstract class ITodoRepository {
  Future<bool> insertTodo(Todo todo);
  Future<bool> updateTodo(Todo todo);
  Future<bool> deleteTodo(Todo todo);
  Future<List<Todo>> fetchTodos();
}

class TodoRepository implements ITodoRepository {
  static final _db = FirebaseFirestore.instance.collection("todos");

  @override
  Future<List<Todo>> fetchTodos() async {
    // List<Todo> data = [];
    
    return await _db.orderBy("createdAt").get().then((value) {
      // value.docs.forEach((element) {
      //   data.add(Todo.fromJson(element.data()));
      // });
      return value.docs.map((doc) => Todo.fromDocRef(doc)).toList();
    });

    // return data;
  }

  @override
  Future<bool> insertTodo(Todo todo) async {
    bool temp = false;
    await _db.add(todo.toDocument()).then((value) => temp = !temp);
    return temp;
  }

  @override
  Future<bool> updateTodo(Todo todo) async {
    bool temp = false;
    await _db.doc(todo.id).update(todo.toDocument()).then((value) => temp = !temp);
    return temp;
  }

  @override
  Future<bool> deleteTodo(Todo todo) async {
    bool temp = false;
    await _db.doc(todo.id).delete().then((value) => temp = !temp);
    return temp;
  }

  // @override
  // Stream fetch() {
  //   return _db.snapshots().map((event) {
  //     return event.docs.map((doc) => Todo.fromDocRef(doc)).toList();
  //   });
  // }
}