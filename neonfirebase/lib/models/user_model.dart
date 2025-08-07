import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final DateTime createdAt;
  String? displayName; 

  UserModel({
    required this.uid,
    required this.email,
    required this.createdAt,
    this.displayName,
  });

  factory UserModel.fromFirestore(Map<String, dynamic> data, String uid) {
    return UserModel(
      uid: uid,
      email: data['email'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      displayName: data['displayName'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'createdAt': FieldValue.serverTimestamp(),
      if (displayName != null) 'displayName': displayName,
    };
  }
}