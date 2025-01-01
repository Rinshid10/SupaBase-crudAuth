import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:one/view_model/imageprovider.dart';

class Imageview extends StatelessWidget {
  const Imageview({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ImageProviders>(
        builder: (context, value, child) {
          if (value.imagesAll.isEmpty) {
            return Center(
              child: Text('No images available'),
            );
          }
          return ListView.builder(
            itemCount: value.imagesAll.length,
            itemBuilder: (context, index) {
              final data = value.imagesAll[index];
              // Debug print to check the data
              print('Image URL: $data');
              return Container(
                height: 200,
                width: 200,
                child: Image.network(
                  data,
                  errorBuilder: (context, error, stackTrace) {
                    return Center(
                      child: Text('Failed to load image'),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
