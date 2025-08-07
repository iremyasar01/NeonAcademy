import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:neonfirebase/models/comment_model.dart';

class CommentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addComment({
    required String postId,
    required String userId,
    required String text,
  }) async {
    try {
      // 1. Yorum modelini oluştur
      final comment = CommentModel(
        id: '', // Firestore otomatik ID oluşturacak
        postId: postId,
        userId: userId,
        text: text,
        timestamp: DateTime.now(),
      );

      // 2. Firestore'a yorumu ekle
      await _firestore
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .add(comment.toFirestore());
          
      // 3. Post dokümanını güncelle (isteğe bağlı)
      await _firestore.collection('posts').doc(postId).update({
        'commentCount': FieldValue.increment(1),
      });
    } catch (e) {
      throw Exception('no comments add: $e');
    }
  }

  Stream<List<CommentModel>> getComments(String postId) {
    try {
      return _firestore
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .orderBy('timestamp', descending: false)
          .snapshots()
          .map((snapshot) => snapshot.docs.map((doc) {
                return CommentModel.fromFirestore(
                  doc,
                  postId, // Post ID'yi geçir
                );
              }).toList());
    } catch (e) {
      throw Exception('no comment: $e');
    }
  }
}