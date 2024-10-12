// ignore_for_file: file_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uc_mas_app/Screens/login.dart';

class HomePage extends StatelessWidget {
  static const String id = 'home_page';
  final String email;

  const HomePage({super.key, required this.email});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomePage'),
      ),
      body: Column(
        children: [
          IconButton(
            icon: const Icon(
              Icons.logout,
              color: Color(0xFF3F4C5C),
            ),
            onPressed: () async {
              SharedPreferences preferences =
                  await SharedPreferences.getInstance();
              await preferences.clear();
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (c) => const Login()));
            },
          ),
        ],
      ),
    );
  }
}
