import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uc_mas_app/Screens/homePage.dart';
import 'package:uc_mas_app/Screens/login.dart';
import 'package:uc_mas_app/firebase_options.dart';
import 'package:uc_mas_app/load_ui.dart';
import 'package:uc_mas_app/Screens/register.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  String? email = await getUserEmail();

  runApp(UCMASApp(
    email: email,
  ));
}

Future<String?> getUserEmail() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('userEmail');
}

class UCMASApp extends StatelessWidget {
  final String? email;

  const UCMASApp({super.key, this.email});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
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
        initialRoute: LoadUi.id,
        routes: {
          LoadUi.id: (context) => const LoadUi(),
          Register.id: (context) => const Register(),
          Login.id: (context) => const Login(),
          HomePage.id: (context) => HomePage(email: email ?? ''),
          //'/home/ranks':
          //'/profile':
          //'/profile/friends':
          //'/virtual-abacus':
          //'/level1-test':
          //'/level2-test':
          //'/mixed-test':
          //'/test-result':
        },
      ),
    );
  }
}
