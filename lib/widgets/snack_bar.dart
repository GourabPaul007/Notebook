import 'package:flutter/material.dart';

class SnackBarWidget {
  const SnackBarWidget._();

  static buildSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.grey[300],
        behavior: SnackBarBehavior.floating,
        elevation: 5,
        width: MediaQuery.of(context).size.width * 5 / 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        duration: const Duration(
          seconds: 4,
        ),
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
