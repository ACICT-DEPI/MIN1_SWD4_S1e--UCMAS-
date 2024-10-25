// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api, avoid_print, must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; // Ensure you have this import

class UsersProfile extends StatefulWidget {
  static const String id = 'profile';
  final String email;

  UsersProfile({super.key, required this.email});

  @override
  _UsersProfileState createState() => _UsersProfileState();
}

class _UsersProfileState extends State<UsersProfile> {
  Map<String, dynamic>? userData;
  bool isLoading = true;

  // Variables to hold correct and wrong answer data
  List<FlSpot> correctAnswers = [];
  List<FlSpot> wrongAnswers = [];

  @override
  void initState() {
    super.initState();
    fetchUserDataByEmail();
  }

  Future<void> fetchUserDataByEmail() async {
    try {
      print('Fetching data for email: ${widget.email}');

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: widget.email)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        print('User data found: ${querySnapshot.docs.first.data()}');

        setState(() {
          userData = querySnapshot.docs.first.data() as Map<String, dynamic>;
          isLoading = false;

          // Fetching correctRatio and wrongRatio data
          correctAnswers = fetchAnswerData(userData!['correctRatio']);
          wrongAnswers = fetchAnswerData(userData!['wrongRatio']);
        });
      } else {
        print('No user data found for email: ${widget.email}');
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User data not found'),
          ),
        );
      }
    } catch (e) {
      print('Error fetching user data: $e');
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading user data: $e'),
        ),
      );
    }
  }

  // Function to convert the fetched data into FlSpot list
  List<FlSpot> fetchAnswerData(List<dynamic> answerData) {
    return List<FlSpot>.generate(answerData.length, (index) {
      return FlSpot(index.toDouble(), answerData[index].toDouble());
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    //Color(0xFFF6897F),
                    Color(0xFF98DDEF),
                    //Color(0xFFFFBF3E),
                    //Color(0xFF137E86),
                    //Color(0xFF60C5A8),
                    //Color(0xFFD54873),
                    Color(0xFFE27AA5),
                    //Color(0xFFE97B11),
                  ], // Replace with your desired colors
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            actions: [
              Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationY(3.14),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.arrow_back,
                      size: 30,
                      color: Colors.black,
                    ),
                  ),
                ),
              )
            ],
          ),
          body: isLoading
              ? const Center(child: CircularProgressIndicator())
              : userData == null
                  ? const Center(child: Text('No user data available'))
                  : ListView(
                      children: [
                        // Profile Header
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(width: 20),
                              Center(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      textAlign: TextAlign.center,
                                      userData!['name'] ?? 'No Name',
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(),
                        // Bio and Contact Info
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'البريد الالكتروني: ${userData!['email'] ?? 'No Email'}',
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'المدينة: ${userData!['governorate'] ?? 'No governorate'}',
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'الدولة: ${userData!['country'] ?? 'No country'}',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),

                        const Divider(),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'أعلى تقييم: ${userData!['correctRatio'] ?? 0}',
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                        const Divider(),
                      ],
                    ),
        ),
      ),
    );
  }
}
