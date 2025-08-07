import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:neonfirebase/service/firestore_service.dart';


class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final TextEditingController _commentController = TextEditingController();
  final FirestoreService _firestoreService = FirestoreService();
  File? _selectedImage;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _selectedImage = File(pickedFile.path));
    }
  }

Future<void> _uploadPost() async {
  if (_selectedImage == null) return;

  try {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw 'User not authenticated';
    }

    await _firestoreService.uploadPost(
      imageFile: _selectedImage!,
      userId: user.uid,
      comment: _commentController.text,
    );
    
    if (mounted) Navigator.pop(context);
  } catch (e) {
    String errorMessage = 'Post upload failed';
    
    if (e is FirebaseException) {
      errorMessage = _firestoreService.parseFirebaseError(e); // Make method public
    } else {
      errorMessage = e.toString();
    }
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Post')
        ,backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: _selectedImage == null
                    ? const Center(child: Icon(Icons.add_a_photo, size: 50))
                    : Image.file(_selectedImage!, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _commentController,
              decoration: const InputDecoration(labelText: 'Comment'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _uploadPost,
              child: const Text('Share Post'),
            ),
          ],
        ),
      ),
    );
  }
  }
