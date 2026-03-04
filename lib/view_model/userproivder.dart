import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:one/model/UserModel/usermodel.dart';
import 'package:one/services/UserServices/userservices.dart';

class Userproivder extends ChangeNotifier {
  Userservices ser = Userservices();
  List<Usermodel> listData = [];

  Future addDatas(Usermodel models) async {
    try {
      await ser.addData(models);
      getalldat();
      notifyListeners();
      log('added succes in pr ');
    } catch (e) {
      log('error to add $e');
    }
  }

  getalldat() async {
    try {
      listData = await ser.getAllData();
      notifyListeners();
      log('suuces to fetch all data and get into list ${listData.length}');
    } catch (e) {
      log('erro found in provider by fecthing all items $e');
    }
  }

  deleteData(int id) async {
    try {
      await ser.delete(id);
      getalldat();
      log('delete succes');
    } catch (e) {
      log('$e');
    }
  }

  updateData(int id, Usermodel model) async {
    try {
      await ser.updateValue(id, model);
      getalldat();
      notifyListeners();
      log('updated work in provider class');
    } catch (e) {
      log('erro found in update $e');
    }
  }
}
