// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uc_mas_app/Screens/homePage.dart';
import 'package:uc_mas_app/Screens/login.dart';

class LoadUi extends StatefulWidget {
  static const String id = 'load_ui';
  const LoadUi({super.key});

  @override
  State<LoadUi> createState() => _LoadUiState();
}

class _LoadUiState extends State<LoadUi> {
  @override
  void initState() {
    super.initState();
    _loadUi();
  }

  Future<void> _loadUi() async {
    String? email = await getUserEmail();
    Navigator.pushReplacementNamed(
        context, email != null ? HomePage.id : Login.id);
  }

  Future<String?> getUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userEmail');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
    );
  }
}
