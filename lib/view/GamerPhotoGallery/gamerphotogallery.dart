import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:one/view/FullScreenImage/fullscreenimage.dart';
import 'package:one/view_model/gamerphotogallerycontroller.dart';
import 'package:one/view_model/imageprovider.dart';
import 'package:provider/provider.dart';

class GamerPhotoGallery extends StatefulWidget {
  final String username;
  final int userId;

  const GamerPhotoGallery({
    super.key,
    required this.username,
    required this.userId,
  });

  @override
  State<GamerPhotoGallery> createState() => _GamerPhotoGalleryState();
}

class _GamerPhotoGalleryState extends State<GamerPhotoGallery> {
  late GamerPhotoGalleryController _controller;

  @override
  void initState() {
    super.initState();
    final imageProvider = Provider.of<ImageProviders>(context, listen: false);
    _controller = GamerPhotoGalleryController(
      imageProvider: imageProvider,
      userId: widget.userId,
    );
    
    // Load images when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.loadImages();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _controller,
      child: Scaffold(
        backgroundColor: const Color(0xFF0A0E21),
        appBar: AppBar(
          backgroundColor: const Color(0xFF16213E),
          elevation: 0,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.username.toUpperCase(),
                style: const TextStyle(
                  color: Color(0xFF00E5FF),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              Text(
                'Photo Gallery',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.5),
                  fontSize: 12,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          iconTheme: const IconThemeData(color: Color(0xFF00E5FF)),
        ),
        body: Consumer<GamerPhotoGalleryController>(
          builder: (context, controller, child) {
            // Show loading indicator
            if (controller.isLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF00E5FF),
                ),
              );
            }

            // Show empty state
            if (!controller.hasImages) {
              return _EmptyState();
            }

            // Show grid view
            return LayoutBuilder(
              builder: (context, constraints) {
                final crossAxisCount =
                    controller.getCrossAxisCount(constraints.maxWidth);
                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: controller.images.length,
                  itemBuilder: (context, index) {
                    final imageUrl = controller.images[index];
                    return _PhotoCard(
                      imageUrl: imageUrl,
                      username: widget.username,
                    );
                  },
                );
              },
            );
          },
        ),
        floatingActionButton: Consumer<GamerPhotoGalleryController>(
          builder: (context, controller, child) {
            return FloatingActionButton.extended(
              onPressed: controller.isUploading
                  ? null
                  : () => _handleAddPhoto(context, controller),
              backgroundColor: const Color(0xFF00E5FF),
              icon: controller.isUploading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Color(0xFF0A0E21),
                      ),
                    )
                  : const Icon(
                      Icons.add_photo_alternate,
                      color: Color(0xFF0A0E21),
                    ),
              label: Text(
                controller.isUploading ? 'Uploading...' : 'Add Photo',
                style: const TextStyle(
                  color: Color(0xFF0A0E21),
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _handleAddPhoto(
      BuildContext context, GamerPhotoGalleryController controller) async {
    // Show loading dialog
    if (context.mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(
            color: Color(0xFF00E5FF),
          ),
        ),
      );
    }

    final success = await controller.addPhoto();

    if (context.mounted) {
      Navigator.pop(context); // Close loading dialog

      // Show success or error message
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Photo added successfully!'),
            backgroundColor: Color(0xFF00E676),
          ),
        );
      } else if (controller.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(controller.errorMessage!),
            backgroundColor: Colors.red.shade700,
          ),
        );
        controller.clearError();
      }
    }
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.photo_library_outlined,
            size: 80,
            color: Colors.white.withValues(alpha: 0.2),
          ),
          const SizedBox(height: 16),
          Text(
            'No photos yet',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.3),
              fontSize: 18,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap + to add photos',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.2),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _PhotoCard extends StatelessWidget {
  final String imageUrl;
  final String username;

  const _PhotoCard({
    required this.imageUrl,
    required this.username,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FullScreenImage(
              imageUrl: imageUrl,
              username: username,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFF00E5FF).withValues(alpha: 0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF00E5FF).withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            fit: StackFit.expand,
            children: [
              kIsWeb
                  ? Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildErrorWidget();
                      },
                    )
                  : Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildErrorWidget();
                      },
                    ),
              // Overlay for tap indication
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.1),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      color: const Color(0xFF16213E),
      child: Center(
        child: Icon(
          Icons.broken_image,
          size: 40,
          color: Colors.white.withValues(alpha: 0.3),
        ),
      ),
    );
  }
}
