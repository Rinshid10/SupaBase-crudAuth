import 'package:flutter/material.dart';
import 'package:one/services/loginServices/loginservices.dart';
import 'package:one/view/LoginAndSignUp/Register/register.dart';
import 'package:provider/provider.dart';

class Loginpage extends StatelessWidget {
  Loginpage({super.key});
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<Loginservices>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(
          title: Text('Titile'),
          backgroundColor: Colors.blue,
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 30, right: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 30,
            children: [
              TextFormField(
                controller: email,
                decoration: InputDecoration(
                    hintText: 'username or email',
                    border: OutlineInputBorder()),
              ),
              TextFormField(
                controller: password,
                decoration: InputDecoration(
                    hintText: 'password', border: OutlineInputBorder()),
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  onPressed: () {
                    value.login(password.text, email.text);
                  },
                  child: Text('login')),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegisterPage()));
                  },
                  child: Text('go to registerpager')),
            ],
          ),
        ),
      ),
    );
  }
}
