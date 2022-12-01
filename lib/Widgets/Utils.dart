import 'package:flutter/material.dart';

class Utils {
  showSnackbar(String text, Color bgColor, BuildContext context) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        behavior: SnackBarBehavior.floating,
        duration: Duration(milliseconds: 800),
        backgroundColor: bgColor,
      ),
    );
  }
}
