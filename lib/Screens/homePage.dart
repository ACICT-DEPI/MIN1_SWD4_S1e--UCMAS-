// ignore_for_file: file_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uc_mas_app/Screens/login.dart';

class HomePage extends StatelessWidget {
  static const String id = 'home_page';
  final String email;

  const HomePage({super.key, required this.email});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWithWidgets(),
    );
  }
}

class BackgroundWithWidgets extends StatelessWidget {
  String _user = "آية";

  BackgroundWithWidgets({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'images/background1.png'), // Your background image here
                fit: BoxFit.cover,
              ),
            ),
          ),
          // AppBar with username and profile avatar
          Positioned(
            top: 40,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'أهلا $_user',
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
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
                        vertical: 10,
                        horizontal: 15), // Add padding to make it more balanced
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
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
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
                                Text('المستخدم${index + 1}',
                                    style: const TextStyle(
                                        fontSize:
                                            12)), // Reverse order of user names
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
                      MaterialPageRoute(builder: (context) => TestPage()),
                    );
                  },
                  child: const Text('Start Test'),
                ),
                const SizedBox(height: 10),

                // Show Score Button
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Dummy Test Page
class TestPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Test')),
      body: const Center(
        child: Text('Test Page Content Here', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}

// Dummy Score Page
class ScorePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Score')),
      body: const Center(
        child: Text('Your Score: 90%', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
