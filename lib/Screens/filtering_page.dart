import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uc_mas_app/Screens/profile.dart';

class FilteringPage extends StatefulWidget {
  FilteringPage({super.key});

  @override
  State<FilteringPage> createState() => _FilteringPageState();
}

class _FilteringPageState extends State<FilteringPage> {
  List<String> countries = ['مصر', 'السعودية', 'الإمارات', 'الأردن'];

  Map<String, List<String>> countryCities = {
    'مصر': [
      'القاهرة',
      'الجيزة',
      'الإسكندرية',
      'الدقهلية',
      'البحر الأحمر',
      'البحيرة',
      'الفيوم',
      'الغربية',
      'الإسماعيلية',
      'المنوفية',
      'المنيا',
      'القليوبية',
      'الوادي الجديد',
      'السويس',
      'أسوان',
      'أسيوط',
      'بني سويف',
      'بورسعيد',
      'دمياط',
      'الشرقية',
      'جنوب سيناء',
      'كفر الشيخ',
      'مطروح',
      'الأقصر',
      'قنا',
      'شمال سيناء',
      'سوهاج'
    ],
    'السعودية': [
      'الرياض',
      'جدة',
      'مكة',
      'المدينة',
      'الدمام',
      'الخبر',
      'الطائف',
      'القصيم'
    ],
    'الإمارات': [
      'أبو ظبي',
      'دبي',
      'الشارقة',
      'عجمان',
      'رأس الخيمة',
      'الفجيرة',
      'أم القيوين'
    ],
    'الأردن': [
      'عمان',
      'الزرقاء',
      'إربد',
      'العقبة',
      'مأدبا',
      'الكرك',
      'الطفيلة',
      'جرش'
    ],
  };

  String? selectedCountry = 'مصر';
  String? selectedCity;

  Stream<QuerySnapshot> getUsersFromFirestore() {
    Query query = FirebaseFirestore.instance.collection('users');

    if (selectedCountry != null && selectedCountry!.isNotEmpty) {
      query = query.where('country', isEqualTo: selectedCountry);
    }

    if (selectedCity != null && selectedCity!.isNotEmpty) {
      query = query.where('governorate', isEqualTo: selectedCity);
    }

    return query.snapshots();
  }

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
          "مجتمع UC Math",
          style: TextStyle(color: Colors.white, fontSize: 30),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(18),
            child: DropdownButtonFormField(
              borderRadius: BorderRadius.circular(8),
              value: selectedCountry,
              items: countries.map((String item) {
                return DropdownMenuItem(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: (String? value) {
                setState(() {
                  selectedCountry = value;
                  selectedCity = null;
                });
              },
              icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF3F4C5C)),
              decoration: const InputDecoration(labelText: 'اختر الدولة'),
            ),
          ),
          if (selectedCountry != null)
            Padding(
              padding: const EdgeInsets.all(18),
              child: DropdownButtonFormField(
                borderRadius: BorderRadius.circular(8),
                value: selectedCity,
                items: countryCities[selectedCountry]!.map((String city) {
                  return DropdownMenuItem(
                    value: city,
                    child: Text(city),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    selectedCity = value;
                  });
                },
                icon:
                    const Icon(Icons.arrow_drop_down, color: Color(0xFF3F4C5C)),
                decoration: const InputDecoration(
                  labelText: 'اختر المدينة',
                ),
              ),
            ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: StreamBuilder<QuerySnapshot>(
                  stream: getUsersFromFirestore(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                          child: const CircularProgressIndicator());
                    }
                    var users = snapshot.data!.docs;

                    return Table(
                      border: TableBorder.all(),
                      columnWidths: const {
                        0: IntrinsicColumnWidth(),
                        1: FlexColumnWidth(),
                        2: IntrinsicColumnWidth(),
                      },
                      children: [
                        const TableRow(
                          decoration: BoxDecoration(color: Color(0xFF3F4C5C)),
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('الرتبة',
                                  style: TextStyle(color: Colors.white)),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('الاسم',
                                  style: TextStyle(color: Colors.white)),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('الإيميل',
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        ),
                        for (var user in users)
                          TableRow(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child:
                                    Text((users.indexOf(user) + 1).toString()),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const Profile()));
                                    },
                                    child: Text(user['name'] ?? 'No Name')),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(user['email'] ?? 'No Email'),
                              ),
                            ],
                          ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
