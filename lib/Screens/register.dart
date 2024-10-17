// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uc_mas_app/Screens/homePage.dart';
import 'package:uc_mas_app/Screens/login.dart';
import 'package:uc_mas_app/components/customTextFormField.dart';
import 'package:uc_mas_app/components/showSnackbar.dart';

class Register extends StatefulWidget {
  static const String id = 'register';
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String? email;
  String? password;
  String? confirmPassword;
  String? name;
  String? selectedCountry;
  String? selectedGovernorate;

  final List<String> countries = [
    'مصر',
    'السعودية',
    'الأردن',
    'الإمارات',
  ];

  final Map<String, List<String>> governorates = {
    'مصر': [
      'القاهرة',
      'الجيزة',
      'الإسكندرية',
      'الشرقية',
      'الغربية',
      'الدقهلية',
      'المنوفية',
      'قليوبية',
      'كفر الشيخ',
      'الفيوم',
      'بني سويف',
      'المنيا',
      'أسيوط',
      'سوهاج',
      'قنا',
      'الأقصر',
      'أسوان',
      'البحر الأحمر',
      'الوادي الجديد',
      'مطروح',
      'شمال سيناء',
      'جنوب سيناء',
      'الإسماعيلية',
      'بورسعيد',
      'السويس',
      'دمياط'
    ],
    'السعودية': [
      'الرياض',
      'جدة',
      'مكة',
      'المدينة المنورة',
      'الشرقية',
      'عسير',
      'الباحة',
      'حائل',
      'القصيم',
      'تبوك',
      'الحدود الشمالية',
      'الجوف',
      'نجران',
      'الليث',
      'صبيا',
      'أملج',
      'الزلفي',
      'المجمعة',
      'العلا',
      'رفحاء',
      'بيشة',
      'سراة عبيدة',
      'تنومة',
      'الظهران',
    ],
    'الأردن': [
      'عمان',
      'إربد',
      'جرش',
      'المفرق',
      'الزرقاء',
      'الكرك',
      'الطفيلة',
      'معان',
      'العقبة',
      'بلد الشمال',
      'عجلون',
      'مأدبا',
      'البيئة',
    ],
    'الإمارات': [
      'أبوظبي',
      'دبي',
      'الشارقة',
      'عجمان',
      'أم القيوين',
      'رأس الخيمة',
      'الفجيرة',
    ],
  };

  @override
  void initState() {
    super.initState();
    email = null;
    password = null;
    confirmPassword = null;
    name = null;
    selectedCountry = null;
    selectedGovernorate = null;
  }

  final GlobalKey<FormState> formKey = GlobalKey();
  bool isLoading = false;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
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
                    height: 100,
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
                            'إنشاء حساب',
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 20),
                          CustomTextFormField(
                            validator: (data) {
                              if (data == null || data.isEmpty) {
                                return 'لا تترك هذا الحقل فارغا';
                              }
                              if (!RegExp(r'^[a-zA-Z\u0621-\u064A\s]+$')
                                  .hasMatch(data)) {
                                return 'الاسم يجب ان يحتوي على احرف فقط';
                              }
                              return null;
                            },
                            onSaved: (value) => name = value,
                            label: 'الاسم',
                            hint: 'الاسم',
                          ),
                          const SizedBox(height: 20),
                          CustomTextFormField(
                            validator: (data) {
                              if (data == null || data.isEmpty) {
                                return 'لا تترك هذا الحقل فارغا';
                              }
                              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$')
                                  .hasMatch(data)) {
                                return 'الايميل غير صحيح';
                              }
                              return null;
                            },
                            onSaved: (value) => email = value,
                            label: 'الايميل',
                            hint: 'User@example.com',
                          ),
                          const SizedBox(height: 20),
                          CustomTextFormField(
                            validator: (data) {
                              formKey.currentState!.save();
                              if (data == null || data.isEmpty) {
                                return 'لا تترك هذا الحقل فارغا';
                              }

                              if (data.length < 8) {
                                return 'كلمة المرور يجب ان تكون على الاقل من 8 حروف';
                              }

                              return null;
                            },
                            onSaved: (value) => password = value,
                            label: 'كلمة المرور',
                            hint: '********',
                            obscureText: true,
                          ),
                          const SizedBox(height: 20),
                          CustomTextFormField(
                            validator: (data) {
                              formKey.currentState!.save();
                              if (data == null || data.isEmpty) {
                                return 'لا تترك هذا الحقل فارغا';
                              }
                              if (data != password) {
                                return 'كلمة المرور غير متطابقة';
                              }
                              return null;
                            },
                            onSaved: (value) => confirmPassword = value,
                            label: 'تأكيد كلمة المرور',
                            hint: '********',
                            obscureText: true,
                          ),
                          const SizedBox(height: 20),
                          const Padding(
                            padding: EdgeInsets.only(left: 12.0, bottom: 10),
                            child: Text(
                              'الدولة',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          DropdownButtonFormField<String>(
                            dropdownColor: const Color(0xFFAEBED4),
                            iconEnabledColor: Colors.white,
                            style: const TextStyle(color: Colors.white),
                            value: selectedCountry,
                            decoration: InputDecoration(
                              hintText: 'اختر الدولة',
                              hintStyle: const TextStyle(color: Colors.white38),
                              filled: true,
                              fillColor: const Color(0xFFAEBED4),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                selectedCountry = value;
                                selectedGovernorate = null;
                              });
                            },
                            items: countries
                                .map((country) => DropdownMenuItem<String>(
                                      value: country,
                                      child: Text(country),
                                    ))
                                .toList(),
                            validator: (value) {
                              if (value == null) {
                                return 'يرجى اختيار الدولة';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          const Padding(
                            padding: EdgeInsets.only(left: 12.0, bottom: 10),
                            child: Text(
                              'المدينة',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          DropdownButtonFormField<String>(
                            dropdownColor: const Color(0xFFAEBED4),
                            iconEnabledColor: Colors.white,
                            style: const TextStyle(color: Colors.white),
                            value: selectedGovernorate,
                            decoration: InputDecoration(
                              hintText: 'اختر المدينة',
                              hintStyle: const TextStyle(color: Colors.white38),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: const Color(0xFFAEBED4),
                            ),
                            onChanged: (value) {
                              setState(() {
                                selectedGovernorate = value;
                              });
                            },
                            items: selectedCountry != null
                                ? governorates[selectedCountry]!
                                    .map((governorate) =>
                                        DropdownMenuItem<String>(
                                          value: governorate,
                                          child: Text(governorate),
                                        ))
                                    .toList()
                                : [],
                            validator: (value) {
                              if (value == null) {
                                return 'يرجى اختيار المدينة';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          Center(
                            child: ElevatedButton(
                              onPressed: () async {
                                if (formKey.currentState!.validate()) {
                                  formKey.currentState!.save();
                                  setState(() {
                                    isLoading = true;
                                  });
                                  try {
                                    await saveUserData();
                                    await saveUserEmail(email!);

                                    showSnackBar(context, 'تم التسجيل بنجاح');
                                  } on FirebaseAuthException catch (e) {
                                    handleFirebaseAuthError(e);
                                  } finally {
                                    setState(() {
                                      isLoading = false;
                                    });
                                  }

                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          HomePage(email: email!),
                                    ),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  side: const BorderSide(
                                      color: Color(0xFF3F4C5C)),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 30),
                              ),
                              child: const Text(
                                'إنشاء الحساب',
                                style: TextStyle(
                                    color: Color(0xFF3F4C5C), fontSize: 16),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Center(
                            child: InkWell(
                              onTap: () {
                                Navigator.pushNamed(context, Login.id);
                              },
                              child: const Text(
                                'لديك حساب بالفعل؟ سجل الدخول الآن',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
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

  Future<void> saveUserEmail(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userEmail', email);
  }

  void handleFirebaseAuthError(FirebaseAuthException e) {
    String message;
    switch (e.code) {
      case 'weak-password':
        message = 'كلمة المرور قصيرة جدا';
        break;
      case 'email-already-in-use':
        message = 'البريد الالكتروني مستخدم من قبل';
        break;
      case 'network-request-failed':
        message = 'فشل الاتصال بالانترنت';
        break;
      default:
        message = 'An error occurred: ${e.code}';
    }
    showSnackBar(context, message);
  }

  saveUserData() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email!, password: password!);
      User? user = userCredential.user;

      if (user != null) {
        await users.add({
          'name': name,
          'email': email,
          'country': selectedCountry,
          'governorate': selectedGovernorate,
        });
      }

      showSnackBar(
        context,
        'تم إنشاء الحساب بنجاح',
      );
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => HomePage(
                    email: email!,
                  )));
    } catch (e) {
      showSnackBar(
        context,
        'حدث خطأ: $e',
      );
    }
  }
}
