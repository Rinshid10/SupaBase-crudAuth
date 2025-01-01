import 'dart:developer';
import 'dart:io';

import 'package:one/model/UserModel/usermodel.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Userservices {
  final supabaseData = Supabase.instance.client.from('crudapp');

  Future addData(Usermodel models) async {
    try {
      await supabaseData.insert([models.toSupabase()]);
      log('added to supabse');
    } catch (e) {
      log('error to add to supabase $e');
    }
  }

  Future<List<Usermodel>> getAllData() async {
    try {
      final respone = await supabaseData.select('*');
      return respone.map((e) => Usermodel.fromSupaBase(e)).toList();
    } catch (e) {
      log('error to feacth all data $e');
    }
    return [];
  }

  Future delete(int id) async {
    try {
      await supabaseData.delete().eq("id", id);
      log('deleted  :  $id');
    } catch (e) {
      log('error in deleting ');
    }
  }

  Future updateValue(int id, Usermodel model) async {
    try {
      await supabaseData.update(model.toSupabase()).eq('id', id);
      log('updateed');
    } catch (e) {
      log('data updated $e');
    }
  }
}
