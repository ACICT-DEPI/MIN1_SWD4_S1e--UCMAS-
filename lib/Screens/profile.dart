import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uc_mas_app/Screens/login.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

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
                transform: Matrix4.rotationY(
                    3.14), // 3.14 radians is 180 degrees (horizontal flip)
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back, // Your icon here
                      size: 30,
                      color: Colors.black,
                    ),
                  ),
                ),
              )
            ],
          ),
          body: ListView(
            children: [
              // Profile Header
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage(
                          'images/user.png'), // Replace with actual avatar image
                    ),
                    const SizedBox(width: 20),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'آية محمد', // Replace with dynamic data
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        Text('@aya_m',
                            style: TextStyle(fontSize: 16, color: Colors.grey)),
                      ],
                    ),
                    Spacer(),
                    IconButton(
                        icon: const Icon(
                          Icons.logout,
                          color: Color(0xFF3F4C5C),
                        ),
                        onPressed: () async {
                          SharedPreferences preferences =
                              await SharedPreferences.getInstance();
                          await preferences.clear();
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (c) => const Login()));
                        },
                      ),
                  ],
                ),
              ),
              const Divider(),

              // Bio and Contact Info
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('البريد الالكتروني: amtsa2003@gmail.com',
                        style: TextStyle(fontSize: 16)),
                    SizedBox(height: 10),
                    Text('رقم الهاتف: 010848848',
                        style: TextStyle(fontSize: 16)),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Text('الأصدقاء: 250', style: TextStyle(fontSize: 16)),
                      ],
                    ),
                  ],
                ),
              ),
              const Divider(),

              // Activity/Stats
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('أعلى تقييم:10', style: TextStyle(fontSize: 16)),
                    SizedBox(height: 10),
                  ],
                ),
              ),
              const Divider(),

              // Action Buttons (for interaction with the user profile)
              Padding(
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // Follow or unfollow the user
                      print('Follow/Unfollow button pressed');
                    },
                    child: const Text('إضافة صديق'),
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
