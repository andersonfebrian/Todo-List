import 'package:flutter/material.dart';
import 'package:todo_list/home.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().whenComplete(() => print("init firebase"));
  runApp(TodoAppHome());
}