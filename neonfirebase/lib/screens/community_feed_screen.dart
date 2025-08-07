import 'package:flutter/material.dart';
import 'package:neonfirebase/models/post_model.dart';
import 'package:neonfirebase/screens/add_post_screen.dart';
import 'package:neonfirebase/service/auth_service.dart';
import 'package:neonfirebase/service/firestore_service.dart';
import 'package:neonfirebase/widgets/postcard.dart';

class CommunityFeedScreen extends StatelessWidget {
  const CommunityFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FirestoreService firestoreService = FirestoreService();
    final AuthService authService = AuthService();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text('Banana Tree Community',),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => authService.signOutUser(),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add_a_photo),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddPostScreen()),
        ),
      ),
      body: StreamBuilder<List<PostModel>>(
        stream: firestoreService.getPostsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No posts available'));
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final post = snapshot.data![index];

              return PostCard(post: post);
            },
          );
        },
      ),
    );
  }
}
