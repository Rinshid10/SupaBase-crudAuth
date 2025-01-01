import 'dart:developer';
import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

class Imageservices {
  Future<void> uploadImage(File image) async {
    final supabase = Supabase.instance.client;
    final bucketName = 'storeimage';
    final fileName = DateTime.now().toIso8601String() + '.jpg';
    try {
      await supabase.storage.from(bucketName).upload(fileName, image);
      final publicUrl =
          supabase.storage.from(bucketName).getPublicUrl(fileName);
      log('Image uploaded successfully. Public URL: $publicUrl');
    } catch (error) {
      log('Error uploading image: $error');
    }
  }

  Future<List<String>> getimags() async {
    try {
      final List<FileObject> objects =
          await Supabase.instance.client.storage.from('storeimage').list();
      final List<String> imageUrls = objects.map((fileObject) {
        return Supabase.instance.client.storage
            .from('storeimage')
            .getPublicUrl(fileObject.name);
      }).toList();
      log('get image succes');
      return imageUrls;
    } catch (e) {
      log('eror found in getting image $e');
    }
    return [];
  }
}
