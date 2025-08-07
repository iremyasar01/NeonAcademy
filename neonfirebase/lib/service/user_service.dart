import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:neonfirebase/models/user_model.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
 Future<void> createUserProfile({
    required String userId,
    required String email,
  }) async {
    try {
      await _firestore.collection('users').doc(userId).set({
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Kullanıcı profili oluşturulamadı: $e');
    }
  }

  Future<UserModel> getUser(String userId) async {
    final doc = await _firestore.collection('users').doc(userId).get();
    return UserModel.fromFirestore(doc.data()!, doc.id);
  }
}