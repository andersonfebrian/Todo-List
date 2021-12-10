import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list/bloc/todos/todo_bloc.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({Key? key}) : super(key: key);

  @override
  _TodoPageState createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {

  final _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodoBloc, TodoState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is TodoLoaded) {
          if (state.todos.isEmpty) {
            return Center(
              child: Text("No todos..."),
            );
          }

          return ListView.builder(
            itemCount: state.todos.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                  "${state.todos[index].body}",
                ),
                leading: Checkbox(
                  value: state.todos[index].isDone,
                  onChanged: (value) {
                    BlocProvider.of<TodoBloc>(context).add(
                      UpdateTodo(state.todos[index]..isDone = value),
                    );
                  },
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      child: Icon(Icons.edit),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.yellow[700],
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("Update Todo"),
                              content: Form(
                                key: _key,
                                child: TextFormField(
                                  initialValue: state.todos[index].body,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Text Field cannot be empty!";
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    BlocProvider.of<TodoBloc>(context).add(
                                      UpdateTodo(state.todos[index]
                                        ..body = value as String),
                                    );
                                  },
                                ),
                              ),
                              actions: [
                                ElevatedButton(
                                  onPressed: () {
                                    if (_key.currentState!.validate()) {
                                      _key.currentState!.save();
                                      Navigator.pop(context);
                                    }
                                  },
                                  child: Text("Update"),
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.green[500],
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    ElevatedButton(
                      child: Icon(Icons.delete),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red[500],
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("Delete Todo?"),
                              actions: [
                                ElevatedButton(
                                  onPressed: () {
                                    BlocProvider.of<TodoBloc>(context).add(
                                      DeleteTodo(state.todos[index]),
                                    );
                                    Navigator.pop(context);
                                  },
                                  child: Text("Delete"),
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.red[500],
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          );
        }

        return Container();
      },
    );
  }
}
