import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:one/model/UserModel/usermodel.dart';
import 'package:one/view_model/imageprovider.dart';
import 'package:one/view_model/userproivder.dart';
import 'package:provider/provider.dart';

class Addpage extends StatelessWidget {
  Addpage({super.key});
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('add page'),
        backgroundColor: Colors.blue,
      ),
      body: Consumer2<Userproivder, ImageProviders>(
        builder: (context, value, imageprovider, child) => SafeArea(
            child: Padding(
          padding: const EdgeInsets.only(left: 30, right: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 30,
            children: [
              GestureDetector(
                onTap: () {
                  imageprovider.pickImage();
                },
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: imageprovider.imageFile != null
                      ? FileImage(imageprovider.imageFile!)
                      : null,
                  child: imageprovider.imageFile == null
                      ? Icon(Icons.person, size: 50)
                      : null,
                ),
              ),
              TextField(
                controller: username,
                decoration: InputDecoration(
                    hintText: 'userName', border: OutlineInputBorder()),
              ),
              TextField(
                controller: password,
                decoration: InputDecoration(
                    hintText: 'password', border: OutlineInputBorder()),
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  onPressed: () {
                    imageprovider.addImage();
                    final save = Usermodel(
                        password: password.text, username: username.text);
                    value.addDatas(save);
                    Navigator.pop(context);
                  },
                  child: Text('save'))
            ],
          ),
        )),
      ),
    );
  }
}
