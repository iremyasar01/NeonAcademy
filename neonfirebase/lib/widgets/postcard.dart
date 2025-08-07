import 'package:flutter/material.dart';
import 'package:neonfirebase/models/post_model.dart';
import 'package:neonfirebase/models/user_model.dart';
import 'package:neonfirebase/service/user_service.dart';
import 'package:neonfirebase/widgets/comment_section.dart';
class PostCard extends StatelessWidget {
  final PostModel post;

  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserModel>(
      future: UserService().getUser(post.userId),
      builder: (context, snapshot) {
        final username = snapshot.hasData
            ? snapshot.data!.displayName ?? snapshot.data!.email
            : 'Loading...';
        
        return Card(
          child: Column(
            children: [
              Image.network(
                post.imageUrl,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
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