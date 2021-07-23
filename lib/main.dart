import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list/bloc/todos/todo_bloc.dart';
import 'package:todo_list/loading.dart';
import 'package:todo_list/repository/todo_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:package_info_plus/package_info_plus.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().whenComplete(() => print("init firebase"));
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<TodoBloc>(
          create: (context) => TodoBloc(
            TodoRepository(),
          ),
        ),
      ],
      child: TodoApp(),
    ),
  );
}

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);

  final _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Todo List"),
        actions: [
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
            child: GestureDetector(
              child: Icon(Icons.more_vert),
              onTap: () async {
                PackageInfo _packageInfo = await PackageInfo.fromPlatform();
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text("Todo List"),
                      content: SizedBox(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(children: [
                                        TextSpan(
                                          text: "App Version: ",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextSpan(
                                          text: "${_packageInfo.version}",
                                        ),
                                      ]),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Divider(
                              height: 10,
                              color: Colors.transparent,
                            ),
                            Row(
                              children: [
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(children: [
                                        TextSpan(
                                          text: "Build Number: ",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextSpan(
                                          text: "${_packageInfo.buildNumber}",
                                        ),
                                      ]),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      actions: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text("Bug Report"),
                                    );
                                  },
                                );
                              },
                              child: RichText(
                                text: TextSpan(children: [
                                  TextSpan(
                                    text: "Report a Bug ",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.white),
                                  ),
                                  WidgetSpan(
                                    child: Icon(
                                      Icons.bug_report_outlined,
                                      size: 18,
                                    ),
                                  ),
                                ]),
                              ),
                            ),
                          ],
                        )
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      body: BlocConsumer<TodoBloc, TodoState>(
        listener: (context, state) {
          print("inside listener: $state");
        },
        builder: (context, state) {
          print("inside builder: $state");

          if (state is TodoInitial) {
            BlocProvider.of<TodoBloc>(context).add(FetchTodos());
            return Loading();
          }

          if (state is TodoLoaded) {
            if (state.todos.isEmpty) {
              return Center(
                child: Text("No Todo..."),
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

          return Loading();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("Create Todo"),
                  content: Form(
                    key: _key,
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Text Field cannot be empty!";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        BlocProvider.of<TodoBloc>(context).add(
                          AddTodo(value as String),
                        );
                      },
                    ),
                  ),
                  actions: [
                    ElevatedButton(
                      child: Text("Create"),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green[500],
                      ),
                      onPressed: () {
                        if (_key.currentState!.validate()) {
                          _key.currentState!.save();
                          Navigator.pop(context);
                        }
                      },
                    ),
                  ],
                );
              });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
