// ignore_for_file: file_names

class Usermodel {
  final String name;
  final String email;
  final String country;
  final String governorate;

  Usermodel({
    required this.name,
    required this.email,
    required this.country,
    required this.governorate,
  });
  factory Usermodel.fromJson(json) {
    return Usermodel(
      name: json['name'],
      email: json['email'],
      country: json['country'],
      governorate: json['governorate'],
    );
  }
}
