import 'package:flutter/material.dart';
import 'package:one/services/loginServices/loginservices.dart';
import 'package:one/view/HomePage/homepage.dart';
import 'package:one/view/LoginAndSignUp/Login/login.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('register'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 30, right: 30),
        child: Consumer<Loginservices>(
          builder: (context, value, child) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 30,
            children: [
              TextFormField(
                controller: value.email,
                decoration: InputDecoration(
                    hintText: 'username or email',
                    border: OutlineInputBorder()),
              ),
              TextFormField(
                controller: value.password,
                decoration: InputDecoration(
                    hintText: 'password', border: OutlineInputBorder()),
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  onPressed: () {
                    value.register();
                  },
                  child: Text('register')),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Loginpage()));
                  },
                  child: Text('go to loginPage')),
            ],
          ),
        ),
      ),
    );
  }
}
