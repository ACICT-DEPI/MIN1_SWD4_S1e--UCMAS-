// ignore_for_file: library_private_types_in_public_api, file_names, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uc_mas_app/Screens/login.dart';
import 'package:uc_mas_app/Screens/test_page.dart';
import 'package:uc_mas_app/components/showSnackbar.dart';
import 'package:uc_mas_app/components/test_types.dart';

class HomePage extends StatelessWidget {
  static const String id = 'home_page';
  final String email;

  const HomePage({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: CustomWidget(),
    );
  }
}

class CustomWidget extends StatefulWidget {
  const CustomWidget({super.key});

  @override
  _BackgroundWithWidgetsState createState() => _BackgroundWithWidgetsState();
}

class _BackgroundWithWidgetsState extends State<CustomWidget> {
  String _user = "loading...";
  TextEditingController _searchController = TextEditingController();
  List<DocumentSnapshot> _searchResults = []; // Store search results

  @override
  void initState() {
    super.initState();
    _fetchUserName();
  }

  Future<void> _fetchUserName() async {
    try {
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
      showSnackBar(context, e.toString());
    }
  }

  Future<void> _searchUsers(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    try {
      // Perform Firestore query to search users based on name
      QuerySnapshot searchSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name',
              isLessThanOrEqualTo: '$query\uf8ff') // For prefix matching
          .get();

      setState(() {
        _searchResults = searchSnapshot.docs;
      });
    } catch (e) {
      print('Error searching users: $e');
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
                Row(
                  children: [
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
                    const SizedBox(width: 10),
                    Text(
                      'أهلا $_user', // Dynamic username from Firestore
                    ),
                  ],
                ),
                Row(
                  children: [
                    InkWell(
                      child: Container(
                        width: 50.0,
                        height: 50.0,
                        child: Image.asset(
                          'images/counter.png',
                          fit: BoxFit
                              .contain, // Keeps aspect ratio, scales down to fit inside the container
                        ),
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, '/virtual-abacus');
                      },
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.logout,
                        color: Color(0xFF3F4C5C),
                      ),
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (c) => const Login()));
                      },
                    ),
                  ],
                )
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
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _searchController,
                  textAlign: TextAlign.right, // Align text to the right
                  onChanged: (value) {
                    _searchUsers(value); // Trigger search on text change
                  },
                  decoration: const InputDecoration(
                    hintText: 'البحث',
                    hintTextDirection: TextDirection.rtl,
                    // Text direction RTL
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                    prefixIconConstraints:
                        BoxConstraints(minWidth: 0, minHeight: 0),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    // Add padding to balance
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ),
          // Search Results List
          Positioned(
            top: 180,
            left: 20,
            right: 20,
            child: _searchResults.isNotEmpty
                ? Container(
                    color: Colors.white.withOpacity(0.9),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _searchResults.length,
                      itemBuilder: (context, index) {
                        var user = _searchResults[index].data()
                            as Map<String, dynamic>;
                        return ListTile(
                          title: Text(user['name']),
                          leading: CircleAvatar(
                            backgroundImage:
                                AssetImage('images/user.png'), // Default avatar
                          ),
                        );
                      },
                    ),
                  )
                : Container(), // Empty container if no results
          ),
          // Floating Card with Top 5 Users
          Positioned(
            top: 200,
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
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        OverflowBar(
                          alignment: MainAxisAlignment.center,
                          overflowSpacing: 20.0,
                          spacing: 30.0,
                          children: [
                            Wrap(
                              alignment: WrapAlignment.center,
                              spacing: 30.0,
                              runSpacing: 20.0,
                              children: List.generate(5, (index) {
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CircleAvatar(
                                      radius: 25,
                                      backgroundImage: AssetImage(
                                        'images/user${index + 1}.png',
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      'المستخدم ${index + 1}',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ],
                                );
                              }),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Start Test Button
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (dialogContext) => AlertDialog(
                              title: const Text(
                                'اختر نوع الاختبار',
                                textDirection: TextDirection.rtl,
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(dialogContext);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => const TestPage(
                                                testType: TestType.level1_1,
                                              )),
                                    );
                                  },
                                  style: const ButtonStyle(
                                    alignment: Alignment.centerRight,
                                  ),
                                  child: const Text(
                                    'المستوى الاول I',
                                    textDirection: TextDirection.rtl,
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(dialogContext);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => const TestPage(
                                                testType: TestType.level1_2,
                                              )),
                                    );
                                  },
                                  style: const ButtonStyle(
                                    alignment: Alignment.centerRight,
                                  ),
                                  child: const Text(
                                    'المستوى الاول II',
                                    textDirection: TextDirection.rtl,
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(dialogContext);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => const TestPage(
                                                testType: TestType.level1,
                                              )),
                                    );
                                  },
                                  style: const ButtonStyle(
                                    alignment: Alignment.centerRight,
                                  ),
                                  child: const Text(
                                    'المستوى الاول III',
                                    textDirection: TextDirection.rtl,
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                              ],
                            ));
                  },
                  child: const Text('ابدأ الاختبار'),
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
