import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo_list/bloc/todo_bloc.dart';
import 'package:todo_list/bloc/todo_event.dart';
import 'package:todo_list/models/todo.dart';
import 'package:todo_list/loading.dart';

class TodoUI {
  static final _key = GlobalKey<FormState>();
  final TodoBloc _bloc;

  TodoUI(this._bloc);

  Widget singleTodoUI(BuildContext context, Todo todo) {
    return GestureDetector(
      onTap: () {
        bool temp = todo.isDone ?? false;
        todo.isDone = !temp;
        // _todoService.updateTodo(todo);
      },
      child: ListTile(
        title: Text(todo.body),
        leading: Checkbox(
          value: todo.isDone,
          onChanged: (value) {
            todo.isDone = value;
            //_todoService.updateTodo(todo);
          },
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) => editDialog(context, todo));
                },
                child: Icon(Icons.edit),
                style: ElevatedButton.styleFrom(primary: Colors.yellow[500])),
            ElevatedButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) => deleteDialog(context, todo));
                },
                child: Icon(Icons.delete),
                style: ElevatedButton.styleFrom(primary: Colors.red[500])),
          ],
        ),
      ),
    );
  }

  AlertDialog insertDialog(BuildContext context) {
    String _temp = "";
    return AlertDialog(
      title: Text("Create Todo"),
      content: Form(
        key: _key,
        child: TextFormField(
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please Enter Something";
            }
            return null;
          },
          onSaved: (value) {
            _temp = value ?? "";
          },
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            if (_key.currentState!.validate()) {
              _key.currentState!.save();
              _bloc.todoEventSink.add(TodoAdded(Todo(_temp)));
            }
          },
          child: Text("Create"),
          style: ElevatedButton.styleFrom(primary: Colors.green[500]),
        )
      ],
    );
  }

  AlertDialog editDialog(BuildContext context, Todo todo) {
    return AlertDialog(
      title: Text("Edit Todo"),
      content: Form(
        key: _key,
        child: TextFormField(
          initialValue: todo.body,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please Enter Something";
            }
            return null;
          },
          onSaved: (value) {
            todo.body = value ?? "";
            print(todo.body);
          },
        ),
      ),
      actions: [
        ElevatedButton(
            onPressed: () {
              if (_key.currentState!.validate()) {
                _key.currentState!.save();
                _bloc.todoEventSink.add(TodoUpdated(todo));
                // _todoService.updateTodo(todo).then((value) {
                //   if (value) {
                //     ScaffoldMessenger.of(context).showSnackBar(
                //         _snackBar(message: "Successfully Edit Todo!"));
                //     Navigator.pop(context);
                //   }
                // });
              }
            },
            child: Text("Edit"))
      ],
    );
  }

  AlertDialog deleteDialog(BuildContext context, Todo todo) {
    return AlertDialog(
      title: Text("Delete Todo?"),
      actions: [
        ElevatedButton(
          onPressed: () {
            _bloc.todoEventSink.add(TodoDeleted(todo));
            ScaffoldMessenger.of(context)
                .showSnackBar(_snackBar(message: "Successfully Deleted Todo!"));
            Navigator.pop(context);
          },
          child: Text("Delete"),
          style: ElevatedButton.styleFrom(primary: Colors.red[500]),
        )
      ],
    );
  }

  SnackBar _snackBar({String? message}) {
    return SnackBar(
        content: message!.isNotEmpty
            ? Text("$message")
            : Text("Successful Operation."));
  }

  Widget mainTodoUI(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Todo List"),
      ),
      body: StreamBuilder<List<Todo>>(
        stream: _bloc.stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData ||
              snapshot.connectionState == ConnectionState.waiting) {
            return Loading();
          }
          return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index) {
                return singleTodoUI(context, snapshot.data![index]);
              });
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context, builder: (context) => insertDialog(context));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
