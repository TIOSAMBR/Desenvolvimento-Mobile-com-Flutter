import 'package:flutter/material.dart';
import '../services/api.dart';

class CommentsScreen extends StatelessWidget {
  final int postId;

  CommentsScreen({required this.postId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Comments")),
      body: FutureBuilder(
        future: ApiService.getCommentsByPostId(postId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData) {
            return Center(child: Text("Nenhum comentário encontrado"));
          }
          final comments = snapshot.data as List;
          return ListView.builder(
            itemCount: comments.length,
            itemBuilder: (context, index) {
              final comment = comments[index];
              return Card(
                margin: EdgeInsets.all(10),
                elevation: 1,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                child: ListTile(
                  leading: Icon(Icons.comment, color: Theme.of(context).primaryColor),
                  title: Text(comment['name'], style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(comment['body']),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
