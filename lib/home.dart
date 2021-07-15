import 'package:flutter/material.dart';

class TodoAppHome extends StatefulWidget {
  const TodoAppHome({Key? key}) : super(key: key);

  @override
  _TodoAppHomeState createState() => _TodoAppHomeState();
}

class _TodoAppHomeState extends State<TodoAppHome> {
  final _formKey = GlobalKey<FormState>();

  String temp = "";

  Map<int, dynamic> data = {
    0: {"body": "Test", "isDone": false},
    1: {"body": "Test", "isDone": false}
  };

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
            if(value == null || value.isEmpty) {
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
                if(_formKey.currentState!.validate()){
                  setState(() {
                    int id = data.keys.last + 1;
                    data.addAll({
                      id: {
                        "body": temp,
                        "isDone": false
                      }
                    });
                    Navigator.pop(context);
                  });
                }
              },
              child: Text("Add Todo")),
          margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Todo List"),
        actions: [
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
            child: GestureDetector(
              child: Icon(Icons.more_vert),
              onTap: () {
                // TODO
              },
            ),
          )
        ],
      ),
      body: Container(
        child: ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text("${data[index]["body"]}"),
                trailing: GestureDetector(
                  onTap: () {
                    setState(() {
                      data[index]["isDone"] = !data[index]["isDone"];
                    });
                  },
                  child: data[index]["isDone"]
                      ? Icon(Icons.check_box)
                      : Icon(Icons.check_box_outline_blank),
                ),
                onTap: () {
                  setState(() {
                    data[index]["isDone"] = !data[index]["isDone"];
                  });
                },
              );
            }),
      ),
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
