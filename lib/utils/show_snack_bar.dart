import 'package:flutter/material.dart';


void showSnackBar(BuildContext context,
    String text, {
      bool isError = false,
      Duration duration = const Duration(seconds: 2),
    }) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
      duration: duration,
      backgroundColor: isError ? Colors.red : Colors.green,
    ),
  );
}
