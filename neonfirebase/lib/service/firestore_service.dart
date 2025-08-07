import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:neonfirebase/models/post_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> uploadPost({
    required File imageFile,
    required String userId,
    required String comment,
  }) async {
    try {
      final String fileName =
          'posts/${DateTime.now().millisecondsSinceEpoch}_${userId.substring(0, 5)}.jpg';

      final Reference storageRef = _storage.ref().child(fileName);

      final UploadTask uploadTask = storageRef.putFile(imageFile);

      // Listen to upload state changes
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        debugPrint('🔄 Upload state: ${snapshot.state}');
        debugPrint(
            '📊 Progress: ${snapshot.bytesTransferred}/${snapshot.totalBytes}');
      });

      final TaskSnapshot snapshot = await uploadTask;

      if (snapshot.state != TaskState.success) {
        throw FirebaseException(
            plugin: 'firebase_storage',
            code: 'upload-failed',
            message: 'Upload completed with state: ${snapshot.state}');
      }

      debugPrint('✅ Upload successful!');

      String imageUrl;
      try {
        imageUrl = await storageRef.getDownloadURL();
        debugPrint('🔗 Download URL: $imageUrl');
      } catch (e) {
        debugPrint('⚠️ URL retrieval failed, retrying...');
        await Future.delayed(const Duration(seconds: 1));
        imageUrl = await storageRef.getDownloadURL();
      }

      // Firestore'a kaydetmek için
      final post = PostModel(
        id: '',
        userId: userId,
        imageUrl: imageUrl,
        comment: comment,
        timestamp: DateTime.now(),
      );

      await _firestore.collection('posts').add(post.toFirestore());
      debugPrint('💾 Post saved to Firestore');
    } on FirebaseException catch (e) {
      throw parseFirebaseError(e);
    } catch (e) {
      throw 'Upload failed: ${e.toString()}';
    }
  }

  String parseFirebaseError(FirebaseException e) {
    switch (e.code) {
      case 'object-not-found':
        return 'File not found at specified location. '
            'Check storage path and file existence.';

      case 'unauthorized':
        return 'You don\'t have permission to access this resource. '
            'Check Firebase Storage rules.';

      case 'canceled':
        return 'Upload canceled by user or system.';

      case 'unauthenticated':
        return 'User not authenticated. Please log in again.';

      case 'quota-exceeded':
        return 'Storage quota exceeded. Free up space or upgrade plan.';

      case 'retry-limit-exceeded':
        return 'Too many failed attempts. Check network and try again later.';

      default:
        return 'Storage error [${e.code}]: ${e.message}';
    }
  }

  Stream<List<PostModel>> getPostsStream() {
    return _firestore
        .collection('posts')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map(PostModel.fromFirestore).toList());
  }
}
