import 'package:flutter/material.dart';

 class LoadUi extends StatefulWidget {
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
     await Future.delayed(const Duration(milliseconds: 1000));
     bool userIsLoggedIn = false;
     if(userIsLoggedIn) {
       Navigator.pushReplacementNamed(context, '/home');
     }
     else {
       Navigator.pushReplacementNamed(context, '/register');
     }
  }

   @override
   Widget build(BuildContext context) {
     return const Scaffold(
       body: Center(
         child: CircularProgressIndicator(
           backgroundColor: Colors.white,
         ),
       ),
     );
   }
 }

