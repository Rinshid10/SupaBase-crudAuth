import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:one/services/ImageServices/imageservices.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ImageProviders extends ChangeNotifier {
  Imageservices ser = Imageservices();
  File? imageFile;
  List<String> imagesAll = [];

  final ImagePicker _imagePicker = ImagePicker();

  Future<void> pickImage() async {
    final pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);

      notifyListeners();
    }
  }

  void addImage() async {
    await ser.uploadImage(imageFile!);
    log(imageFile.toString());
    getImage();
    log("img added!");
  }

  void getImage() async {
    try {
      imagesAll = await ser.getimags();
      notifyListeners();
      log('image added to list ${imagesAll.length}');
    } catch (e) {
      log('error found to  add to list by images');
    }
  }
}
