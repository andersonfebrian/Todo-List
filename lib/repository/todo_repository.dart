import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_list/models/todo.dart';
import 'package:todo_list/repository/shared/repository.dart';

class TodoRepository implements Repository {
  static final _db = FirebaseFirestore.instance.collection("todos");

  Future<List<Todo>> fetchAll() async {
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
  Future<bool> insert(todo) async {
    bool temp = false;
    await _db.add(todo.toDocument()).then((value) => temp = !temp);
    return temp;
  }

  @override
  Future<bool> update(todo) async {
    bool temp = false;
    await _db.doc(todo.id).update(todo.toDocument()).then((value) => temp = !temp);
    return temp;
  }

  @override
  Future<bool> delete(todo) async {
    bool temp = false;
    await _db.doc(todo.id).delete().then((value) => temp = !temp);
    return temp;
  }

  @override
  Stream fetch() {
    return _db.snapshots().map((event) {
      return event.docs.map((doc) => Todo.fromDocRef(doc)).toList();
    });
  }
}