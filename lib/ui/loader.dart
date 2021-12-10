import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  final double? width, height;

  const Loader({@required this.width, @required this.height});

  @override
  Widget build (BuildContext context) {
    return SizedBox(
      width: this.width,
      height: this.height,
      child: CircularProgressIndicator(
        color: Colors.white,
      ),
    );
  }
}