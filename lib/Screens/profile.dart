<<<<<<< HEAD
// ignore_for_file: library_private_types_in_public_api

=======
>>>>>>> 42dcd223373840b54b7a88febd64609498d5f698
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uc_mas_app/Screens/login.dart';

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

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

<<<<<<< HEAD
=======

>>>>>>> 42dcd223373840b54b7a88febd64609498d5f698
  void getCurrentUser() async {
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      setState(() {
        user = currentUser;
      });
<<<<<<< HEAD
      await fetchUserDataByEmail();
=======
      await fetchUserData();
>>>>>>> 42dcd223373840b54b7a88febd64609498d5f698
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

<<<<<<< HEAD
  Future<void> fetchUserDataByEmail() async {
    try {
      // Log the user's email
      print('Fetching data for email: ${user!.email}');

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: user!.email)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Log the retrieved document data
        print('User data found: ${querySnapshot.docs.first.data()}');

        setState(() {
          userData = querySnapshot.docs.first.data() as Map<String, dynamic>;
=======

  Future<void> fetchUserData() async {
    try {
      // Log the user's uid
      print('Fetching data for user: ${user!.uid}');

      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();

      // Check if the document exists
      if (doc.exists) {
        // Log the retrieved document data
        print('User data found: ${doc.data()}');

        setState(() {
          userData = doc.data() as Map<String, dynamic>;
>>>>>>> 42dcd223373840b54b7a88febd64609498d5f698
          isLoading = false;
        });
      } else {
        // Log if document is not found
<<<<<<< HEAD
        print('No user data found for email: ${user!.email}');
=======
        print('No user data found for user: ${user!.uid}');
>>>>>>> 42dcd223373840b54b7a88febd64609498d5f698

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
                                  Text(
                                    userData!['email'] ?? 'No Email',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
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
<<<<<<< HEAD
                                'المدينة: ${userData!['governorate'] ?? 'No governrate'}',
=======
                              'المدينة: ${userData!['governrate'] ?? 'No governrate'}',
>>>>>>> 42dcd223373840b54b7a88febd64609498d5f698
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
                        // Activity/Stats
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
                      ],
                    ),
        ),
      ),
    );
  }
<<<<<<< HEAD
}
=======
}
>>>>>>> 42dcd223373840b54b7a88febd64609498d5f698
