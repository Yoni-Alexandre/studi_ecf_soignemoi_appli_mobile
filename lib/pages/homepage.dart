import 'package:flutter/material.dart';
import 'package:studi_ecf_soignemoi_appli_mobile/controllers/auth_controller.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connexion', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF3498DB),
      ),
      body: Container(
        color: const Color(0xFFF1F1F1),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo.jpg', height: 150),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(color: Color(0xFF3498DB)),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF3498DB)),
                ),
              ),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: 'Mot de passe',
                labelStyle: TextStyle(color: Color(0xFF3498DB)),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF3498DB)),
                ),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: const Color(0xFF3498DB),
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                onPressed: () async {
                  final email = emailController.text;
                  final password = passwordController.text;

                  print('Email: $email');
                  print('Password: $password');

                  await context.read<AuthController>().login(email, password);

                  if (context.read<AuthController>().isLoggedIn) {
                    print('Login successful');
                    Navigator.pushReplacementNamed(context, '/dashboard');
                  } else {
                    print('Login failed');
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Échec de la connexion')),
                    );
                  }
                },
                child: const Text('Se connecter'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
