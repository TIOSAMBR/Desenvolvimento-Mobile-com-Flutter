import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api.dart';
import 'login.dart';
import 'comentarios.dart';
import '../models/usuario.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List posts;

  @override
  void initState() {
    super.initState();
    _checkLogin();
    _loadPosts();
  }

  void _checkLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('user')) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginScreen()));
    }
  }

  void _loadPosts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final user = User.fromJson(prefs.getString('user')!);
    final userPosts = await ApiService.getPostsByUserId(user.id);
    setState(() {
      posts = userPosts;
    });
  }

  void _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Posts"),
        actions: [IconButton(icon: Icon(Icons.logout), onPressed: _logout)],
      ),
      body: posts == null
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return Card(
                  margin: EdgeInsets.all(10),
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  child: ListTile(
                    title: Text(
                      post['title'],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(post['body'], maxLines: 2, overflow: TextOverflow.ellipsis),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => CommentsScreen(postId: post['id'])),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
