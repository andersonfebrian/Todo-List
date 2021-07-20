import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo_list/models/todo.dart';
import 'package:todo_list/loading.dart';

// class TodoUI {
//   static final _key = GlobalKey<FormState>();
//   static final _db = FirebaseFirestore.instance;

//   static Widget singleTodoUI(BuildContext context, Todo todo) {
//     return GestureDetector(
//       onTap: () {
//         bool temp = todo.isDone ?? false;
//         todo.isDone = !temp;
//         TodoService.updateTodo(todo);
//       },
//       child: ListTile(
//         title: Text(todo.body),
//         leading: Checkbox(
//           value: todo.isDone,
//           onChanged: (value) {
//             todo.isDone = value;
//             TodoService.updateTodo(todo);
//           },
//         ),
//         trailing: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             ElevatedButton(
//                 onPressed: () {
//                   showDialog(
//                       context: context,
//                       builder: (context) => editDialog(context, todo));
//                 },
//                 child: Icon(Icons.edit),
//                 style: ElevatedButton.styleFrom(primary: Colors.yellow[500])),
//             ElevatedButton(
//                 onPressed: () {
//                   showDialog(
//                       context: context,
//                       builder: (context) => deleteDialog(context, todo));
//                 },
//                 child: Icon(Icons.delete),
//                 style: ElevatedButton.styleFrom(primary: Colors.red[500])),
//           ],
//         ),
//       ),
//     );
//   }

//   static AlertDialog insertDialog(BuildContext context) {
//     String _temp = "";
//     return AlertDialog(
//       title: Text("Create Todo"),
//       content: Form(
//         key: _key,
//         child: TextFormField(
//           validator: (value) {
//             if (value == null || value.isEmpty) {
//               return "Please Enter Something";
//             }
//             return null;
//           },
//           onSaved: (value) {
//             _temp = value ?? "";
//           },
//         ),
//       ),
//       actions: [
//         ElevatedButton(
//           onPressed: () {
//             if (_key.currentState!.validate()) {
//               _key.currentState!.save();
//               TodoService.insertTodo(new Todo(_temp)).then((value) {
//                 if (value) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                       _snackBar(message: "Successfully Created Todo!"));
//                   Navigator.pop(context);
//                 }
//               });
//             }
//           },
//           child: Text("Create"),
//           style: ElevatedButton.styleFrom(primary: Colors.green[500]),
//         )
//       ],
//     );
//   }

//   static AlertDialog editDialog(BuildContext context, Todo todo) {
//     return AlertDialog(
//       title: Text("Edit Todo"),
//       content: Form(
//         key: _key,
//         child: TextFormField(
//           initialValue: todo.body,
//           validator: (value) {
//             if (value == null || value.isEmpty) {
//               return "Please Enter Something";
//             }
//             return null;
//           },
//           onSaved: (value) {
//             todo.body = value ?? "";
//             print(todo.body);
//           },
//         ),
//       ),
//       actions: [
//         ElevatedButton(
//             onPressed: () {
//               if (_key.currentState!.validate()) {
//                 _key.currentState!.save();
//                 TodoService.updateTodo(todo).then((value) {
//                   if (value) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                         _snackBar(message: "Successfully Edit Todo!"));
//                     Navigator.pop(context);
//                   }
//                 });
//               }
//             },
//             child: Text("Edit"))
//       ],
//     );
//   }

//   static AlertDialog deleteDialog(BuildContext context, Todo todo) {
//     return AlertDialog(
//       title: Text("Delete Todo?"),
//       actions: [
//         ElevatedButton(
//           onPressed: () {
//             TodoService.deleteTodo(todo).then((value) {
//               if (value) {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                     _snackBar(message: "Successfully Deleted Todo!"));
//                 Navigator.pop(context);
//               } else {
//                 ScaffoldMessenger.of(context).showSnackBar(_snackBar(
//                     message: "Something went wrong! Please try again later."));
//               }
//             });
//           },
//           child: Text("Delete"),
//           style: ElevatedButton.styleFrom(primary: Colors.red[500]),
//         )
//       ],
//     );
//   }

//   static SnackBar _snackBar({String? message}) {
//     return SnackBar(
//         content: message!.isNotEmpty
//             ? Text("$message")
//             : Text("Successful Operation."));
//   }

//   Widget mainTodoUI(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Todo List"),
//       ),
//       body: StreamBuilder(
//         stream: _db.collection('todos').snapshots(),
//         builder: (context,
//             AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
//           if (snapshot.connectionState == ConnectionState.none) {
//             return Container();
//           }

//           if (!snapshot.hasData ||
//               snapshot.connectionState == ConnectionState.waiting) {
//             return Loading();
//           }

//           if (snapshot.hasError) {
//             return Container();
//           }

//           return ListView.builder(
//               itemCount: snapshot.data!.size,
//               itemBuilder: (context, index) {
//                 return singleTodoUI(
//                     context, Todo.fromDocRef(snapshot.data!.docs[index]));
//               });
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           showDialog(
//               context: context, builder: (context) => insertDialog(context));
//         },
//         child: Icon(Icons.add),
//       ),
//     );
//   }
// }
