import 'dart:convert';

class OtherUserInfo {
  String? id;
  String? email;
  String? name;
  String? phone;
  String? location;
  String? dob;
  String? gender;
  String? nationality;
  String? maritalStatus;
  String? profession;
  String? aboutMe;
  String? image;
  String? accountType;

  OtherUserInfo({
    this.id,
    this.email,
    this.name,
    this.phone,
    this.location,
    this.dob,
    this.gender,
    this.nationality,
    this.maritalStatus,
    this.profession,
    this.aboutMe,
    this.image,
    this.accountType,
  });

  // Factory method to create an instance from JSON
  factory OtherUserInfo.fromJson(Map<String, dynamic> json) {
    return OtherUserInfo(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      phone: json['phone'],
      location: json['location'],
      dob: json['dob'],
      gender: json['gender'],
      nationality: json['nationality'],
      maritalStatus: json['marital_status'],
      profession: json['profession'],
      aboutMe: json['about_me'],
      image: json['image'],
      accountType: json['account_type'],
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'phone': phone,
      'location': location,
      'dob': dob,
      'gender': gender,
      'nationality': nationality,
      'marital_status': maritalStatus,
      'profession': profession,
      'about_me': aboutMe,
      'image': image,
      'account_type': accountType,
    };
  }
}
