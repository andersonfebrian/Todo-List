import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list/bloc/page_toggle/page_toggle_bloc.dart';
import 'package:todo_list/bloc/todos/todo_bloc.dart';
import 'package:todo_list/pages/styles/styles.dart';
import 'package:todo_list/ui/loader.dart';
import 'package:todo_list/utils/utils.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _key = GlobalKey<FormState>();
  bool? _loading = false;

  String? _email, _password;

  void _loadState() => setState(() => this._loading = !this._loading!);
  
  void _dismissKeyboard(BuildContext context) => FocusScope.of(context).unfocus();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: MediaQuery.of(context).size.height / 1.5,
        width: MediaQuery.of(context).size.width / 1.25,
        child: Form(
          key: _key,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(child: SizedBox(child: FlutterLogo(), height: 100, width: 100,),),
              Divider(height: 15.0, color: Colors.transparent,),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Email cannot be empty!";
                  }
                  return null;
                },
                onSaved: (value) => this._email = value,
                decoration: const TFFBorder("Email"),
              ),
              Divider(
                height: 25.0,
                color: Colors.transparent,
              ),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Password cannot be empty!";
                  }

                  return null;
                },
                onSaved: (value) => this._password = value,
                decoration: const TFFBorder("Password"),
                obscureText: true,
              ),
              Divider(
                height: 25.0,
                color: Colors.transparent,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: TextSpan(children: [
                      TextSpan(
                        text: "Don't have an account? ",
                        style: TextStyle(color: Colors.black),
                      ),
                      TextSpan(
                        text: "Register",
                        style: TextStyle(
                          color: Colors.lightBlue[400],
                        ),
                        recognizer: TapGestureRecognizer()..onTap = () => BlocProvider.of<PageToggleBloc>(context).add(ToggleRegisterPage()),
                      ),
                    ]),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (_key.currentState!.validate()) {
                        _key.currentState!.save();
                        _loadState();
                        _dismissKeyboard(context);
                        try {
                          await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                                  email: this._email!,
                                  password: this._password!)
                              .then((value) {
                            _loadState();
                            BlocProvider.of<TodoBloc>(context).add(FetchTodos());
                          });
                        } on FirebaseAuthException catch (e) {
                          _loadState();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(bindAuthException(e)),),
                          );
                        }
                      }
                    },
                    child: this._loading!
                        ? Loader(width: 10, height: 10)
                        : Text("Login"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

