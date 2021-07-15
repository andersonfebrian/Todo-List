import 'package:flutter/material.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({ Key? key }) : super(key: key);

  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2)).whenComplete(() => Navigator.popAndPushNamed(context, "/home"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            Divider(color: Colors.transparent,),
            Text("Loading your Todo...")
          ],
        )
      ),
    );
  }
}