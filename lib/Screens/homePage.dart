<<<<<<< HEAD
// ignore_for_file: file_names, use_build_context_synchronously, library_private_types_in_public_api

import 'package:flutter/material.dart';

import 'package:uc_mas_app/Screens/test_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uc_mas_app/components/showSnackbar.dart';
=======
// ignore_for_file: file_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uc_mas_app/Screens/login.dart';
import 'package:uc_mas_app/Screens/test_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
>>>>>>> 42dcd223373840b54b7a88febd64609498d5f698

class HomePage extends StatelessWidget {
  static const String id = 'home_page';
  final String email;

  const HomePage({super.key, required this.email});
<<<<<<< HEAD

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
=======
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
>>>>>>> 42dcd223373840b54b7a88febd64609498d5f698
      body: CustomWidget(),
    );
  }
}

class CustomWidget extends StatefulWidget {
<<<<<<< HEAD
  const CustomWidget({super.key});
=======
  CustomWidget({super.key});
>>>>>>> 42dcd223373840b54b7a88febd64609498d5f698

  @override
  _BackgroundWithWidgetsState createState() => _BackgroundWithWidgetsState();
}

class _BackgroundWithWidgetsState extends State<CustomWidget> {
<<<<<<< HEAD
  String _user = "loading...";
=======
  String _user = "loading..."; 
>>>>>>> 42dcd223373840b54b7a88febd64609498d5f698

  @override
  void initState() {
    super.initState();
    _fetchUserName();
  }

  Future<void> _fetchUserName() async {
    try {
<<<<<<< HEAD
      // Get the email from the HomePage constructor
      String email =
          (context.findAncestorWidgetOfExactType<HomePage>() as HomePage).email;

      // Fetch the user data from Firestore using the email
      QuerySnapshot userQuery = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      // Check if the query returned any documents
      if (userQuery.docs.isNotEmpty) {
        setState(() {
          _user = userQuery.docs.first['name'] ??
              'User'; // Fallback to 'User' if no name field
=======
      // Get the current user ID from Firebase Authentication
      String uid = FirebaseAuth.instance.currentUser?.uid ?? '';

      // Fetch the user data from Firestore using the UID
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();

      // Check if the document exists and fetch the user's name
      if (userDoc.exists) {
        setState(() {
          _user = userDoc['name'] ?? 'User'; // Fallback to 'User' if no name field
>>>>>>> 42dcd223373840b54b7a88febd64609498d5f698
        });
      } else {
        setState(() {
          _user = 'User not found'; // Fallback if user doesn't exist
        });
      }
    } catch (e) {
      setState(() {
        _user = 'Error loading user';
      });
<<<<<<< HEAD
      showSnackBar(context, e.toString());
=======
      print('Error fetching user data: $e');
>>>>>>> 42dcd223373840b54b7a88febd64609498d5f698
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Stack(
        children: [
          // AppBar with username and profile avatar
          Positioned(
            top: 40,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'أهلا $_user', // Dynamic username from Firestore
<<<<<<< HEAD
=======
                  
>>>>>>> 42dcd223373840b54b7a88febd64609498d5f698
                ),
                const SizedBox(width: 10),
                // Profile icon
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, '/profile');
                  },
                  child: const CircleAvatar(
                    radius: 25,
                    backgroundImage: AssetImage(
                        'images/user.png'), // Your profile image here
                  ),
                ),
              ],
            ),
          ),
          // Search bar below the AppBar
          Positioned(
            top: 100,
            left: 20,
            right: 20,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(25),
              ),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: TextField(
                  textAlign: TextAlign.right, // Align text to the right
                  decoration: InputDecoration(
                    hintText: 'البحث',
                    hintTextDirection: TextDirection.rtl, // Text direction RTL
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                    prefixIconConstraints:
                        BoxConstraints(minWidth: 0, minHeight: 0),
                    contentPadding: EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15), // Add padding to balance
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ),
          // Floating Card with Top 5 Users
          Positioned(
            top: 180,
            left: 20,
            right: 20,
            child: Column(
              children: [
                Card(
                  color: Colors.white.withOpacity(0.9),
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Text(
                              'أفضل 5 مستخدمين',
                              textAlign: TextAlign.right,
<<<<<<< HEAD
=======
                              
>>>>>>> 42dcd223373840b54b7a88febd64609498d5f698
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        // Reverse the order of the user avatars
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(5, (index) {
                            return Column(
                              children: [
                                CircleAvatar(
                                  radius: 25,
                                  backgroundImage: AssetImage(
                                      'images/user${index + 1}.png'), // Reverse order of user images
                                ),
                                const SizedBox(height: 5),
<<<<<<< HEAD
                                Text(
                                  'المستخدم${index + 1}',
                                ),
=======
                                Text('المستخدم${index + 1}',
                                    ),
>>>>>>> 42dcd223373840b54b7a88febd64609498d5f698
                              ],
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Start Test Button
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
<<<<<<< HEAD
                      MaterialPageRoute(builder: (context) => const TestPage()),
=======
                      MaterialPageRoute(
                          builder: (context) => const TestPage()),
>>>>>>> 42dcd223373840b54b7a88febd64609498d5f698
                    );
                  },
                  child: const Text('Start Test'),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
