import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_list/models/todo.dart';

class TodoService {

  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static Future<List<Todo>> fetch() async {
    List<Todo> data = [];

    // await _db.collection("todos").get().then((value) {
    //   value.docs.forEach((element) {
    //     data.add(Todo.fromJson(element.data()));
    //   });
    // });
    
    await _db.collection("todos").orderBy("createdAt").get().then((value) {
      value.docs.forEach((element) {
        data.add(Todo.fromJson(element.data()));
      });
    });

    return data;
  }

  static Future<bool> insertTodo(Todo todo) async {
    bool temp = false;

    await _db.collection('todos').doc().set(todo.toJson()).then((value) {
      temp = !temp;
    }).onError((error, stackTrace) {temp = !temp;});

    return temp;
  }

  static Future<bool> updateTodo(Todo todo) async {
    bool temp = false;

    await _db.collection('todos').where('uuid', isEqualTo: todo.uuid).get().then((value) {
      value.docs.forEach((element) {
        todo.updatedAt = DateTime.now();
        element.reference.update(todo.toJson());
      });
      temp = true;
    }).onError((error, stackTrace) {temp = false;});

    return temp;
  }

  static Future<bool> deleteTodo(Todo todo) async {
    bool temp = false;

    await _db.collection("todos").where("uuid", isEqualTo: todo.uuid).get().then((value) {
      value.docs.forEach((element) {
        element.reference.delete();
      });
      temp = true;
    }).onError((error, stackTrace) {temp = false;});

    return temp;
  }
}
