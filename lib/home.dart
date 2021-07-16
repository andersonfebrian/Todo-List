import 'package:flutter/material.dart';
import 'package:todo_list/services/todo_service.dart';
import 'package:todo_list/models/todo.dart';

class TodoAppHome extends StatefulWidget {
  const TodoAppHome({Key? key}) : super(key: key);

  @override
  _TodoAppHomeState createState() => _TodoAppHomeState();
}

class _TodoAppHomeState extends State<TodoAppHome> {
  final _formKey = GlobalKey<FormState>();

  String temp = "";
  List<Todo> data = [];

  SnackBar snackBar({String? message}) {
    return SnackBar(content: Text(message ?? ""));
  }

  AlertDialog addTodoDialog(BuildContext context) {
    return AlertDialog(
      title: Text("What to do?"),
      content: Form(
        key: _formKey,
        child: TextFormField(
          onChanged: (value) {
            setState(() {
              temp = value;
            });
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter something!";
            }
            return null;
          },
        ),
      ),
      actions: [
        Container(
          child: TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    Todo tempData = new Todo(temp);
                    data.add(tempData);
                    TodoService.insertTodo(tempData).then((value) {
                      if (value) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            snackBar(
                                message: "Successfully Added Todo!"));
                      }
                      Navigator.pop(context);
                    });
                  });
                }
              },
              child: Text("Add Todo")),
          margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
        )
      ],
    );
  }

  AlertDialog deleteTodoDialog(BuildContext context, Todo item) {
    return AlertDialog(
      title: Text("Delete Todo?"),
      actions: [
        TextButton(
            onPressed: () async {
              await TodoService.deleteTodo(item).then((value) {
                if (value) {
                  setState(() {
                    data.remove(item);
                    ScaffoldMessenger.of(context).showSnackBar(
                        snackBar(message: "Deleted Todo!"));
                  });
                  Navigator.pop(context);
                }
              });
            },
            child: Container(
              margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
              child: Text("Confirm"),
            )),
      ],
    );
  }

  AlertDialog updateTodoDialog(BuildContext context, Todo item) {
    return AlertDialog(
      title: Text("New Todo"),
      content: Form(
        key: _formKey,
        child: TextFormField(
          initialValue: item.body,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter something!";
            }
            return null;
          },
          onChanged: (value){
            setState(() {
              temp = value;
            });
          },
        ),
      ),
      actions: [
        Container(
          child: TextButton(
            child: Text("Update"),
            onPressed: () async {
              if(_formKey.currentState!.validate()){
                item.body = temp;
                TodoService.updateTodo(item).then((value) {
                  if(value){
                    setState(() {
                      data.where((element) => element == item);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(snackBar(message: "Updated Todo!"));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(snackBar(message: "Something Went Wrong..."));
                  }
                  Navigator.pop(context);
                });
              }
            },
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    TodoService.fetch().then((value) => data = value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Todo List"),
        actions: [
          // Container(
          //   margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
          //   child: GestureDetector(
          //     child: Icon(Icons.more_vert),
          //     onTap: () {
          //       // TODO
          //     },
          //   ),
          // ),
        ],
      ),
      body: Container(
          child: ListView(
        children: [
          for (var item in data)
            GestureDetector(
              child: ListTile(
                title: Text(item.body),
                leading: (item.isDone ?? false)
                    ? Icon(Icons.check_box)
                    : Icon(Icons.check_box_outline_blank),
                trailing: GestureDetector(
                  child: Icon(Icons.delete),
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) => deleteTodoDialog(context, item));
                  },
                ),
              ),
              onTap: () async {
                setState(() {
                  bool temp = item.isDone ?? false;
                  item.isDone = !temp;
                });
                await TodoService.updateTodo(item)
                    .then((value) => print(value));
              },
              onLongPress: () {
                showDialog(
                    context: context,
                    builder: (context) => updateTodoDialog(context, item));
              },
            )
        ],
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context, builder: (context) => addTodoDialog(context));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
