import 'package:flutter/material.dart';
import 'package:uc_mas_app/Screens/profile.dart';

// ignore: must_be_immutable
class FrindsPage extends StatelessWidget {
  FrindsPage({super.key});

  List<Map<String, String>> Users = [
    {'name': 'Alice Smith', 'email': 'alice@example.com'},
    {'name': 'Bob Johnson', 'email': 'bob@example.com'},
    {'name': 'Charlie Brown', 'email': 'charlie@example.com'},
    {'name': 'David Lee', 'email': 'david@example.com'},
    {'name': 'Eve Green', 'email': 'eve@example.com'},
    {'name': 'Frank White', 'email': 'frank@example.com'},
    {'name': 'Grace Black', 'email': 'grace@example.com'},
    {'name': 'Hank Blue', 'email': 'hank@example.com'},
    {'name': 'Ivy Red', 'email': 'ivy@example.com'},
    {'name': 'Jack Yellow', 'email': 'jack@example.com'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF3F4C5C),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          " الأصدقاء",
          style: TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: ListView.builder(
            itemCount: Users.length,
            itemBuilder: (context, index) {
              return Card(
                  margin: const EdgeInsets.all(12),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Color(0xFF3F4C5C),
                      child: Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                    ),
                    title: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Profile()));
                      },
                      child: Text(
                        Users[index]['name']!,
                        style: const TextStyle(
                          color: Color(0xFF3F4C5C),
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ));
            }),
      ),
    );
  }
}
