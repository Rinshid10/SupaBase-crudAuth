import 'dart:developer';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:one/services/ImageServices/imageservices.dart';

class ImageProviders extends ChangeNotifier {
  Imageservices ser = Imageservices();
  Uint8List? imageBytes;
  List<String> imagesAll = [];

  final ImagePicker _imagePicker = ImagePicker();

  Future<void> pickImage() async {
    final pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      imageBytes = await pickedFile.readAsBytes();
      notifyListeners();
    }
  }

  Future<String?> addImage() async {
    if (imageBytes == null) {
      log('No image selected');
      return null;
    }
    final response = await ser.uploadImage(imageBytes!);

    await getImage();

    return response;
  }

  void clearImage() {
    imageBytes = null;
    notifyListeners();
  }

  Future<void> getImage() async {
    try {
      imagesAll = await ser.getimags();
      notifyListeners();
      log('image added to list ${imagesAll.length}');
    } catch (e) {
      log('error found to  add to list by images');
    }
  }
}
