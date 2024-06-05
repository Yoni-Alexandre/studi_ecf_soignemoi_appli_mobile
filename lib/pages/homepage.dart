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
        title: Text('Connexion'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Mot de passe'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final email = emailController.text;
                final password = passwordController.text;

                print('Email: $email'); // Debugging statement
                print('Password: $password'); // Debugging statement

                await context.read<AuthController>().login(email, password);

                if (context.read<AuthController>().isLoggedIn) {
                  print('Login successful'); // Debugging statement
                  Navigator.pushReplacementNamed(context, '/dashboard');
                } else {
                  print('Login failed'); // Debugging statement
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Échec de la connexion')),
                  );
                }
              },
              child: Text('Se connecter'),
            ),
          ],
        ),
      ),
    );
  }
}