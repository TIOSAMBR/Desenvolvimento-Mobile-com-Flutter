import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teste/models/usuario.dart';
import '../services/api.dart';
import 'home.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();   // Controlador Usuario
  final _passwordController = TextEditingController();  // Controlador Senha
  void _login() async {
    final username = _usernameController.text.trim();
    _passwordController.text.trim();  

    if (username.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Nome de usuário é obrigatório")));
      return;
    }

    final userMap = await ApiService.getUserByUsername(username);
    if (userMap != null) {
      
      final user = User(
        id: userMap['id'],
        name: userMap['name'],
        username: userMap['username'],
        email: userMap['email'],
      );
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('user', user.toJson());
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Usuário inválido")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Bem Vindo!",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40),
            // Campo de usuário
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: "Usuário",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            SizedBox(height: 20),
            // Campo para a senha 
            TextField(
              controller: _passwordController,
              obscureText: true,  
              decoration: InputDecoration(
                labelText: "Senha",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            SizedBox(height: 20),
            // Botão de login
            ElevatedButton(
              onPressed: _login,
              child: Text("Login"),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
