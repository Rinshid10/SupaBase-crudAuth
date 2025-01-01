import 'package:flutter/material.dart';
import 'package:one/model/UserModel/usermodel.dart';
import 'package:one/view_model/userproivder.dart';
import 'package:provider/provider.dart';

class Editpage extends StatelessWidget {
  String? username;
  String? password;
  int? id;
  Editpage(
      {super.key,
      required this.password,
      required this.username,
      required this.id});

  @override
  Widget build(BuildContext context) {
    TextEditingController name = TextEditingController(text: username);
    TextEditingController passwords = TextEditingController(text: password);
    return Consumer<Userproivder>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(
          title: Text('Edit page'),
          backgroundColor: Colors.blue,
        ),
        body: SafeArea(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 30,
          children: [
            TextFormField(
              controller: name,
              decoration: InputDecoration(
                  hintText: 'userName', border: OutlineInputBorder()),
            ),
            TextFormField(
              controller: passwords,
              decoration: InputDecoration(
                  hintText: 'password', border: OutlineInputBorder()),
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                onPressed: () {
                  final save =
                      Usermodel(password: passwords.text, username: name.text);
                  value.updateData(id!, save);

                  Navigator.pop(context);
                },
                child: Text('save'))
          ],
        )),
      ),
    );
  }
}
