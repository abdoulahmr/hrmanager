import 'package:flutter/material.dart';
import 'Functions.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top:300.0,bottom: 20.0,left: 20.0,right: 20.0),
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                controller: usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                loginWithUsernameAndPassword(
                  usernameController.text,
                  passwordController.text,
                  context,
                );
              },
              style: ButtonStyle(
                fixedSize: MaterialStateProperty.all(const Size(300, 50)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
              ),
              child: const Text(
                "Login",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}