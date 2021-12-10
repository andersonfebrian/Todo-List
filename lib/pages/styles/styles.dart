import 'package:flutter/material.dart';

class TFFBorder extends InputDecoration {
  final String? labelText;

  static const _errBorder = OutlineInputBorder(
    borderRadius: const TFFBorderRadius(),
    borderSide: const TFFErrorBorderSide(),
  );

  static const _enabledBorder = OutlineInputBorder(
    borderRadius: const TFFBorderRadius(),
  );

  const TFFBorder(this.labelText)
      : super(
          errorBorder: _errBorder,
          focusedErrorBorder: _errBorder,
          enabledBorder: _enabledBorder,
          focusedBorder: _enabledBorder,
          isDense: true,
        );
}

class TFFBorderRadius extends BorderRadius {
  static const _radius = Radius.circular(25.0);

  const TFFBorderRadius() : super.all(_radius);
}

class TFFErrorBorderSide extends BorderSide {
  const TFFErrorBorderSide()
      : super(
          color: Colors.red,
        );
}
