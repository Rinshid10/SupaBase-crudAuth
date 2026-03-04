import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:one/model/UserModel/usermodel.dart';
import 'package:one/services/UserServices/userservices.dart';
import 'package:one/view_model/imageprovider.dart';

class GamerPhotoGalleryController extends ChangeNotifier {
  final ImageProviders imageProvider;
  final Userservices ser = Userservices();
  final int userId;
  
  Usermodel? _currentUser;
  bool _isLoading = false;
  bool _isUploading = false;
  String? _errorMessage;
  String? _successMessage;

  GamerPhotoGalleryController({
    required this.imageProvider,
    required this.userId,
  });

  bool get isLoading => _isLoading;
  bool get isUploading => _isUploading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;
  List<String> get images => _currentUser?.images ?? [];
  bool get hasImages => images.isNotEmpty;
  Usermodel? get currentUser => _currentUser;







  /// Loads the specific user's data
  Future<void> _loadUserData() async {
    try {
      final allData = await ser.getAllData();
      _currentUser = allData.firstWhere(
        (user) => user.id == userId,
        orElse: () => Usermodel(
          id: userId,
          username: '',
          password: '',
          images: [],
        ),
      );
      log('User data loaded: ${_currentUser?.username} with ${_currentUser?.images?.length ?? 0} images');
    } catch (e) {
      log('Error loading user data: $e');
      _errorMessage = 'Error loading user data: $e';
    }
  }

  /// Calculates the cross axis count based on screen width
  int getCrossAxisCount(double width) {
    if (width > 1200) return 4;
    if (width > 800) return 3;
    if (width > 500) return 2;
    return 2;
  }

  /// Loads user-specific images from the database
  Future<void> loadImages() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // First load the user's data
      await _loadUserData();
      log('Images loaded successfully: ${images.length}');
    } catch (e) {
      _errorMessage = 'Error loading images: $e';
      log('Error loading images: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Picks an image from the gallery
  Future<bool> pickImage() async {
    try {
      await imageProvider.pickImage();
      return imageProvider.imageFile != null;
    } catch (e) {
      _errorMessage = 'Error picking image: $e';
      notifyListeners();
      log('Error picking image: $e');
      return false;
    }
  }

  /// Uploads the selected image and saves it to user's image list
  Future<bool> uploadImage() async {
    if (imageProvider.imageFile == null) {
      _errorMessage = 'No image selected';
      notifyListeners();
      return false;
    }

    // Ensure user data is loaded
    if (_currentUser == null) {
      await _loadUserData();
    }

    if (_currentUser == null || _currentUser!.id == null) {
      _errorMessage = 'User data not found';
      notifyListeners();
      return false;
    }

    _isUploading = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      // Upload image to storage
      final imageUrl = await imageProvider.addImage();
      
      if (imageUrl != null && imageUrl.isNotEmpty) {
        // Add image URL to user's images list
        final currentImages = _currentUser!.images ?? [];
        final updatedImages = [...currentImages, imageUrl];
        
        // Create updated model with new image list
        final updatedModel = Usermodel(
          id: _currentUser!.id,
          username: _currentUser!.username ?? '',
          password: _currentUser!.password ?? '',
          userId: _currentUser!.userId,
          imageUrl: _currentUser!.imageUrl,
          images: updatedImages,
        );

        // Update user in database
        await ser.updateValue(_currentUser!.id!, updatedModel);
        
        // Update local state
        _currentUser = updatedModel;
        
        _successMessage = 'Photo added successfully!';
        log('Image uploaded and saved to user: $imageUrl');
        log('User now has ${updatedImages.length} images');
        
        _isUploading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Failed to upload image';
        _isUploading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Error uploading photo: $e';
      _isUploading = false;
      notifyListeners();
      log('Error uploading image: $e');
      return false;
    }
  }

  /// Complete flow: Pick and upload image
  Future<bool> addPhoto() async {
    // First pick the image
    final picked = await pickImage();
    if (!picked) {
      return false;
    }

    // Then upload it
    return await uploadImage();
  }

  /// Clears error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Clears success message
  void clearSuccess() {
    _successMessage = null;
    notifyListeners();
  }

  /// Clears all messages
  void clearMessages() {
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }
}
