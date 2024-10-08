import 'package:flutter/material.dart';
import 'package:uc_mas_app/load_ui.dart';
import 'package:uc_mas_app/register.dart';

void main() {
  runApp(const UCMASApp());
}

class UCMASApp extends StatelessWidget {
  const UCMASApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UC Math App',
      theme: ThemeData(
        colorScheme: const ColorScheme(
          primary: Color(0xFF3F4C5C),
          secondary: Color(0xFFFD8751),
          error: Colors.red,
          surface: Colors.white,
          onPrimary: Color(0xFF869AAA),
          onSecondary: Color(0xFFE1C1A0),
          onError: Colors.red,
          onSurface: Colors.black,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoadUi(),
        '/register': (context) => const Register(),
        //'/login':
        //'/home':
        //'/home/ranks':
        //'/profile':
        //'/profile/friends':
        //'/virtual-abacus':
        //'/level1-test':
        //'/level2-test':
        //'/mixed-test':
        //'/test-result':
      },
    );
  }
}