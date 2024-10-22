// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:uc_mas_app/Screens/login.dart';
import 'UserActivityGraph.dart'; // Import your graph widget

class Profile extends StatefulWidget {
  static const String id = 'profile';

  const Profile({super.key});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  User? user;
  Map<String, dynamic>? userData;
  bool isLoading = true;

  // Variables to hold correct and wrong answer data
  List<FlSpot> correctAnswers = [];
  List<FlSpot> wrongAnswers = [];

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      setState(() {
        user = currentUser;
      });
      await fetchUserDataByEmail();
    } else {
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User is not logged in'),
        ),
      );
    }
  }

  Future<void> fetchUserDataByEmail() async {
    try {
      print('Fetching data for email: ${user!.email}');

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: user!.email)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        print('User data found: ${querySnapshot.docs.first.data()}');

        setState(() {
          userData = querySnapshot.docs.first.data() as Map<String, dynamic>;
          correctAnswers = fetchAnswerData(userData!['correctRatio']);
          wrongAnswers = fetchAnswerData(userData!['wrongRatio']);
          isLoading = false;
        });
      } else {
        print('No user data found for email: ${user!.email}');
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
            title: const Text('حسابي'),
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
              ),
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
                            children: [
                              CircleAvatar(
                                radius: 50,
                                backgroundImage: userData!['avatarUrl'] != null
                                    ? NetworkImage(userData!['avatarUrl'])
                                    : const AssetImage(
                                        'images/user.png',
                                      ) as ImageProvider,
                              ),
                              const SizedBox(width: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    userData!['name'] ?? 'No Name',
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Spacer(),
                              IconButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/friends');
                                },
                                icon: const Icon(Icons.people),
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
                              Row(
                                children: [
                                  Text(
                                    'البريد الالكتروني: ${userData!['email'] ?? 'No Email'}',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  const Spacer(),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.logout,
                                      color: Color(0xFF3F4C5C),
                                    ),
                                    onPressed: () async {
                                      await FirebaseAuth.instance.signOut();
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (c) => const Login()));
                                    },
                                  ),
                                ],
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
                                'أعلى تقييم: ${userData!['highScore'] ?? 0}',
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                        const Divider(),
                        // User Activity Graph
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Container(
                            height: 300, // Adjust height as needed
                            child: UserActivityGraph(
                              correctAnswersData: correctAnswers,
                              wrongAnswersData: wrongAnswers,
                            ),
                          ),
                        ),
                      ],
                    ),
        ),
      ),
    );
  }
}
