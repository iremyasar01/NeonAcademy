import 'package:flutter/material.dart';
import 'package:neonfirebase/models/post_model.dart';
import 'package:neonfirebase/models/user_model.dart';
import 'package:neonfirebase/service/user_service.dart';
import 'package:neonfirebase/service/firestore_service.dart';
import 'package:neonfirebase/widgets/comment_section.dart';

class PostCard extends StatelessWidget {
  final PostModel post;

  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final firestoreService = FirestoreService();

    return FutureBuilder<UserModel>(
      future: UserService().getUser(post.userId),
      builder: (context, snapshot) {
        final username = snapshot.hasData
            ? snapshot.data!.displayName ?? snapshot.data!.email
            : 'Loading...';

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: Alignment.topRight,
                children: [
                  Image.network(
                    post.imageUrl,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  IconButton(
                    icon: const Icon(Icons.download, color: Colors.white),
                    onPressed: () async {
                      try {
                        await firestoreService.downloadPostImage(post.imageUrl);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Photo downloaded to gallery"),
                            ),
                          );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Download error: $e")),
                          );
                        }
                      }
                    },
                  ),
                ],
              ),
              ListTile(
                title: Text(username),
                subtitle: Text(post.comment),
              ),
              CommentSection(postId: post.id),
            ],
          ),
        );
      },
    );
  }
}
