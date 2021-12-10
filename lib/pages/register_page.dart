import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list/bloc/page_toggle/page_toggle_bloc.dart';
import 'package:todo_list/pages/styles/styles.dart';
import 'package:todo_list/utils/utils.dart';
import 'package:todo_list/ui/loader.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _key = GlobalKey<FormState>();
  bool _loading = false;

  String? _email, _password;

  void _loadState() => setState(() => this._loading = !this._loading);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width / 1.25,
        child: Form(
          key: _key,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Register Account",
                style: TextStyle(fontSize: 24),
              ),
              Divider(
                height: 10,
                color: Colors.transparent,
              ),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Email cannot be empty!";
                  }

                  return null;
                },
                onSaved: (value) => this._email = value,
                decoration: TFFBorder("Email"),
              ),
              Divider(
                height: 10,
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
                        text: "Already have an account? ",
                        style: TextStyle(color: Colors.black),
                      ),
                      TextSpan(
                        text: "Login",
                        style: TextStyle(
                          color: Colors.lightBlue[400],
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () =>
                              BlocProvider.of<PageToggleBloc>(context)
                                  .add(ToggleLoginPage()),
                      ),
                    ]),
                  ),

                  ElevatedButton(
                      onPressed: this._loading
                          ? null
                          : () async {
                              if (_key.currentState!.validate()) {
                                _key.currentState!.save();
                                _loadState();
                                _registerAccount(this._email, this._password);
                              }
                            },
                      child: this._loading
                          ? Loader(width: 10, height: 10)
                          : Text(
                              "Register",
                            )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _registerAccount(String? email, String? password) async {
      try {
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email!, password: password!);
      } on FirebaseAuthException catch (e) {
        _loadState();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(bindAuthException(e))),
        );
      }
  }
}
