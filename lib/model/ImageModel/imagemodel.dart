class ImageMetadata {
  final int id;
  final String fileName;
  final String publicUrl;

  // Constructor
  ImageMetadata({
    required this.id,
    required this.fileName,
    required this.publicUrl,
  });

  factory ImageMetadata.fromMap(Map<String, dynamic> map) {
    return ImageMetadata(
      id: map['id'] ?? 0,
      fileName: map['file_name'],
      publicUrl: map['public_url'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'file_name': fileName,
      'public_url': publicUrl,
    };
  }
}
