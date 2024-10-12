// ignore_for_file: file_names

import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String message, {int duration = 2000}) {
  if (context.mounted && ScaffoldMessenger.maybeOf(context) != null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(milliseconds: duration),
        backgroundColor: Colors.white,
        content: Center(
          child: Text(
            message,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Color(0xFF3F4C5C),
            ),
          ),
        ),
      ),
    );
  }
}
