import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:neonfirebase/models/comment_model.dart';
import 'package:neonfirebase/models/user_model.dart';
import 'package:neonfirebase/service/comment_service.dart';
import 'package:neonfirebase/service/user_service.dart';
class CommentSection extends StatefulWidget {
  final String postId;
  const CommentSection({super.key, required this.postId});

  @override
  State<CommentSection> createState() => _CommentSectionState();
}
class _CommentSectionState extends State<CommentSection> {
  final TextEditingController _controller = TextEditingController();
  final CommentService _commentService = CommentService();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          StreamBuilder<List<CommentModel>>(
            stream: _commentService.getComments(widget.postId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              
              final comments = snapshot.data ?? [];
              
              return Column(
                children: comments.map((comment) => 
                  FutureBuilder<UserModel>(
                    future: UserService().getUser(comment.userId),
                    builder: (context, userSnapshot) {
                      final username = userSnapshot.hasData
                          ? userSnapshot.data!.displayName ?? userSnapshot.data!.email
                          : 'Loading...';
                      
                      return ListTile(
                        title: Text(username),
                        subtitle: Text(comment.text),
                      );
                    },
                  )
                ).toList(),
              );
            },
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    hintText: 'add comment...',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: () {
                  if (_controller.text.isNotEmpty) {
                    _commentService.addComment(
                      postId: widget.postId,
                      userId: FirebaseAuth.instance.currentUser!.uid,
                      text: _controller.text,
                    );
                    _controller.clear();
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}