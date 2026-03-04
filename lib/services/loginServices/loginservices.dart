import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:one/view/HomePage/homepage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Loginservices extends ChangeNotifier {
  TextEditingController password = TextEditingController();
  TextEditingController email = TextEditingController();

  Future register() async {
    try {
     final response =  await Supabase.instance.client.auth
           .signUp(password: password.text, email: email.text);
      log('register succes${response.user?.id}');


      notifyListeners();
    } on AuthApiException catch (e) {
      log(' error found in register ${e.message} + ${e.statusCode}');
    }
  }

  Future login(password, email, BuildContext context) async {
    try {
      final response = await Supabase.instance.client.auth
          .signInWithPassword(password: password, email: email);
      log('login success: ${response.user?.id}');
      Navigator.push(context, MaterialPageRoute(builder: (context) => HompePage()));
      notifyListeners();
    } on AuthApiException catch (e) {
      log('error found in login: ${e.message} ${e.statusCode}');
    }
  }
}
