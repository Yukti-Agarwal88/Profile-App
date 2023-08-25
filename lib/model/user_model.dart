import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  // final String? id;
  final String fullName;
  final String occupation;
  final String email;
  final String country;
  final String status;
  final String photoUrl;

  const UserModel(
      {
      // this.id,
      required this.photoUrl,
      required this.fullName,
      required this.occupation,
      required this.email,
      required this.country,
      required this.status});

  toJson() {
    return {
      "FullName": fullName,
      "Designation": occupation,
      "PhotoUrl": photoUrl,
      "Email": email,
      "Country": country,
      "Status": status
    };
  }

  factory UserModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return UserModel(
        // id: document.id,
        photoUrl: data['PhotoUrl'],
        fullName: data['FullName'],
        occupation: data['Designation'],
        email: data['Email'],
        country: data['Country'],
        status: data['Status']);
  }
}
