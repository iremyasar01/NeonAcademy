import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:neonfirebase/models/comment_model.dart';

class CommentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addComment({
    required String postId,
    required String userId,
    required String text,
  }) async {
    try {
      // Yorum modelini oluştur
      final comment = CommentModel(
        id: '', // Firestore otomatik ID oluşturacak
        postId: postId,
        userId: userId,
        text: text,
        timestamp: DateTime.now(),
      );

      // Firestore'a yorumu ekle (alt koleksiyon olarak)
      await _firestore
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .add(comment.toFirestore());

      // HATA AYIKLAMA: Başarı mesajı
      debugPrint('✅ Yorum başarıyla eklendi: $postId');
    } catch (e) {
      // DETAYLI HATA MESAJI
      debugPrint('🔥 YORUM EKLEME HATASI: $e');
      throw Exception('Yorum eklenemedi: $e');
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
          .handleError((error) {
            debugPrint('🔥 YORUM GETİRME HATASI: $error');
          })
          .map((snapshot) {
            // HATA AYIKLAMA: Kaç yorum geldi
            //debugPrint('📥 $postId için ${snapshot.docs.length} yorum alındı');
            
            return snapshot.docs.map((doc) {
              return CommentModel.fromFirestore(
                doc,
                postId,
              );
            }).toList();
          });
    } catch (e) {
      debugPrint('🔥 YORUM AKIŞI HATASI: $e');
      throw Exception('Yorumlar getirilemedi: $e');
    }
  }
}