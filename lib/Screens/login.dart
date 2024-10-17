// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uc_mas_app/Screens/homePage.dart';
import 'package:uc_mas_app/Screens/register.dart';
import 'package:uc_mas_app/components/customTextFormField.dart';
import 'package:uc_mas_app/components/showSnackbar.dart';

class Login extends StatefulWidget {
  static const String id = 'login';
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String? email;
  String? password;
  bool isLoading = false;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: Scaffold(
          body: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 50.0),
                    child: Column(
                      children: [
                        Text(
                          'أهلا بك في',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'UC Math App',
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF3F4C5C),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Image(
                    image: NetworkImage(
                        'https://t4.ftcdn.net/jpg/04/56/73/31/360_F_456733197_IkANz9OFFyeqniYkm72Xss5UOwnCieMW.jpg'),
                    width: 300,
                    height: 270,
                  ),
                  Container(
                    width: (MediaQuery.of(context).size.width) >= 600
                        ? MediaQuery.of(context).size.width * 0.4
                        : MediaQuery.of(context).size.width * 0.9,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 10),
                    decoration: const BoxDecoration(
                      color: Color(0xFF3F4C5C),
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(40)),
                    ),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'تسجيل الدخول',
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 20),
                          CustomTextFormField(
                            validator: (data) => data == null || data.isEmpty
                                ? 'لا تترك هذا الحقل فارغا'
                                : null,
                            onSaved: (value) => email = value?.trim(),
                            label: 'الايميل',
                            hint: 'user@example.com',
                          ),
                          const SizedBox(height: 20),
                          CustomTextFormField(
                            validator: (data) => data == null || data.isEmpty
                                ? 'لا تترك هذا الحقل فارغا'
                                : null,
                            onSaved: (value) => password = value,
                            label: 'كلمة المرور',
                            hint: '********',
                            obscureText: true,
                          ),
                          const SizedBox(height: 10),
                          _buildForgotPasswordButton(context),
                          _buildLoginButton(context),
                          _buildRegisterButton(context),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InkWell _buildForgotPasswordButton(BuildContext context) {
    return InkWell(
      hoverColor: Colors.transparent,
      onTap: () async {
        if (email == null || email!.isEmpty) {
          showSnackBar(context, 'من فضلك أدخل البريد الالكتروني');
          return;
        }
        await _sendPasswordResetEmail(context);
      },
      child: const Text(
        'نسيت كلمة المرور؟',
        style: TextStyle(
          fontSize: 15,
          color: Colors.white60,
        ),
        textAlign: TextAlign.end,
      ),
    );
  }

  Future<void> _sendPasswordResetEmail(BuildContext context) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email!);
      showSnackBar(context,
          "تم إرسال البريد الإلكتروني لإعادة تعيين كلمة المرور إلى $email");
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, 'خطأ: ${e.message}');
    } catch (e) {
      showSnackBar(context, 'خطأ غير متوقع: ${e.toString()}');
    }
  }

  Center _buildLoginButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () async {
          if (formKey.currentState!.validate()) {
            formKey.currentState!.save();
            setState(() => isLoading = true);
            await _loginUser(context);
          }
        },
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: Color(0xFF3F4C5C)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 30),
        ),
        child: const Text(
          'تسجيل الدخول',
          style: TextStyle(color: Color(0xFF3F4C5C), fontSize: 16),
        ),
      ),
    );
  }

  Future<void> _loginUser(BuildContext context) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email!, password: password!);
      await _saveUserEmail(email!);
      showSnackBar(context, 'تم تسجيل الدخول بنجاح', duration: 300);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage(email: email!)),
      );
    } on FirebaseAuthException catch (e) {
      _handleFirebaseAuthError(e, context);
    } catch (e) {
      showSnackBar(context, e.toString());
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _handleFirebaseAuthError(FirebaseAuthException e, BuildContext context) {
    switch (e.code) {
      case 'user-not-found':
        showSnackBar(context, 'لا يوجد مستخدم مسجل بهذا البريد الالكتروني');
        break;
      case 'wrong-password':
        showSnackBar(context, 'كلمة المرور غير صحيحة.');
        break;
      case 'invalid-email':
        showSnackBar(context, 'البريد الالكتروني غير صالح');
        break;
      case 'network-request-failed':
        showSnackBar(context, 'فشل الاتصال بالانترنت');
        break;
      default:
        showSnackBar(context, 'خطأ: ${e.message}');
    }
  }

  Center _buildRegisterButton(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: () {
          Navigator.pushNamed(context, Register.id);
        },
        child: const Text(
          "ليس لديك حساب؟ انشاء حساب",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Future<void> _saveUserEmail(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userEmail', email);
  }
}
