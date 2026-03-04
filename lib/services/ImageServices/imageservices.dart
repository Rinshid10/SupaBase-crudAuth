import 'dart:developer';
import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';

class Imageservices {
  Future<String?> uploadImage(Uint8List imageBytes) async {
    final supabase = Supabase.instance.client;
    final bucketName = 'storeimage';
    final fileName = DateTime.now().toIso8601String() + '.jpg';
    try {
      await supabase.storage.from(bucketName).uploadBinary(fileName, imageBytes);
      final publicUrl =
          supabase.storage.from(bucketName).getPublicUrl(fileName);
      log('Image uploaded successfully. Public URL: $publicUrl');
      return publicUrl;
    } catch (error) {
      log('Error uploading image: $error');
    }
    return null;
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
