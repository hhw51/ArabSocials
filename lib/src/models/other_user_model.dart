// lib/models/user.dart

class User {
  final int id;
  final String? name;
  final String? email;
  final String? phone;
  final String? location;
  final String? maritalStatus;
  final List<String>? interests; // Changed from String? to List<String>?
  final String? profession;
  final List<String>? socialLinks; // Changed from String? to List<String>?
  final String? image;
  final String accountType;
  final String? aboutMe;
  final String? nationality;
  final String? dob;
  final String? gender;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.location,
    this.maritalStatus,
    this.interests,
    this.profession,
    this.socialLinks,
    this.image,
    required this.accountType,
    this.aboutMe,
    this.nationality,
    this.dob,
    this.gender,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    try {
      return User(
        id: json['id'],
        name: json['name']?? "",
        email: json['email']?? "",
        phone: json['phone']?? "",
        location: json['location']?? "",
        maritalStatus: json['marital_status']?? "",
        interests: json['interests'] != null
            ? List<String>.from(json['interests'])
            : null,
        profession: json['profession']?? "",
        socialLinks: json['social_links'] != null
            ? List<String>.from(json['social_links'])
            : null,
        image: json['image']?? "",
        accountType: json['account_type'],
        aboutMe: json['about_me']?? "",
        nationality: json['nationality']?? "",
        dob: json['dob']?? "",
        gender: json['gender']?? "",
      );
    } catch (e) {
      print('Error parsing User JSON: $e');
      throw Exception('Error parsing User JSON: $e');
    }
  }


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'location': location,
      'marital_status': maritalStatus,
      'interests': interests,
      'profession': profession,
      'social_links': socialLinks,
      'image': image,
      'account_type': accountType,
      'about_me': aboutMe,
      'nationality': nationality,
      'dob': dob,
      'gender': gender,
    };
  }
}
