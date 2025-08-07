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
      // Generate unique filename with timestamp
      final String fileName = 'posts/${DateTime.now().millisecondsSinceEpoch}_${userId.substring(0, 5)}.jpg';
      
      // Log upload attempt
      debugPrint('🔼 Starting upload: $fileName');
      debugPrint('📏 File size: ${imageFile.lengthSync()} bytes');

      // Create storage reference
      final Reference storageRef = _storage.ref().child(fileName);
      
      // Start upload task
      final UploadTask uploadTask = storageRef.putFile(imageFile);
      
      // Listen to upload state changes
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        debugPrint('🔄 Upload state: ${snapshot.state}');
        debugPrint('📊 Progress: ${snapshot.bytesTransferred}/${snapshot.totalBytes}');
      });

      // Wait for upload completion
      final TaskSnapshot snapshot = await uploadTask;
      
      // Verify successful upload
      if (snapshot.state != TaskState.success) {
        throw FirebaseException(
          plugin: 'firebase_storage',
          code: 'upload-failed',
          message: 'Upload completed with state: ${snapshot.state}'
        );
      }

      debugPrint('✅ Upload successful!');

      // Get download URL with retry logic
      String imageUrl;
      try {
        imageUrl = await storageRef.getDownloadURL();
        debugPrint('🔗 Download URL: $imageUrl');
      } catch (e) {
        debugPrint('⚠️ URL retrieval failed, retrying...');
        await Future.delayed(const Duration(seconds: 1));
        imageUrl = await storageRef.getDownloadURL();
      }


      // Save to Firestore
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
      // Detailed error diagnostics
      debugPrint('🔥 FIREBASE ERROR DETAILS:');
      debugPrint('  Code: ${e.code}');
      debugPrint('  Message: ${e.message}');
      debugPrint('  Plugin: ${e.plugin}');
      debugPrint('  Stack: ${e.stackTrace}');
      
      throw parseFirebaseError(e);
    } catch (e, st) {
      debugPrint('💥 UNEXPECTED ERROR: $e');
      debugPrint('📝 Stack trace: $st');
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