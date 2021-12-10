import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list/bloc/page_toggle/page_toggle_bloc.dart';
import 'package:todo_list/bloc/todos/todo_bloc.dart';
import 'package:todo_list/loading.dart';
import 'package:todo_list/pages/login_page.dart';
import 'package:todo_list/pages/register_page.dart';
import 'package:todo_list/pages/todo_page.dart';
import 'package:todo_list/repository/todo_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
        BlocProvider<PageToggleBloc>(
          create: (context) => PageToggleBloc(),
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

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _key = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  bool? _loading = false;
  User? _user;

  @override
  void initState() {
    _auth.authStateChanges().listen((event) {
      _user = event;
    });
    super.initState();
  }

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
      body: StreamBuilder<User?>(
        stream: _auth.authStateChanges(),
        builder: (context, state) {
          print("called - ${state.hasData}");

          if(state.hasData || _user != null) {
            BlocProvider.of<TodoBloc>(context).add(FetchTodos());
            return TodoPage();
          }

          return BlocBuilder<PageToggleBloc, PageToggleState>(
            builder: (context, state) {
              if (state is PageToggleInitial || state is LoginPageToggled) {
                return const LoginPage();
              }

              if (state is RegisterPageToggled) {
                return const RegisterPage();
              }
              return Container();
            },
          );
        },
      ),
      floatingActionButton: StreamBuilder<User?>(
        stream: _auth.authStateChanges(),
        builder: (context, state) {
          if (_user != null || state.hasData) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton(
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
                if (_user != null)
                  FloatingActionButton(
                    onPressed: () {
                      setState(() {
                        _loading = !_loading!;
                        _user = null;
                      });
                      _auth.signOut();
                      BlocProvider.of<PageToggleBloc>(context).add(ToggleLoginPage());
                    },
                    child: Text("Logout"),
                  ),
              ],
            );
          }

          return Container();
        },
      ),
    );
  }
}