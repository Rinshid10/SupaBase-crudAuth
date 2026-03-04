class Usermodel {
  String? username;
  String? password;
  int? id; // Database primary key (int8)
  String? userId; // Foreign key to auth.users (uuid)
  String? imageUrl;
  List<String>? images = [];

  Usermodel({
    this.id,
    this.userId,
    required this.password,
    required this.username,
    this.imageUrl,
    this.images,
  });

  factory Usermodel.fromSupaBase(Map<String, dynamic> supa) {
    // Handle images list - convert from dynamic to List<String>
    List<String>? imagesList;
    if (supa['image_List'] != null) {
      if (supa['image_List'] is List) {
        imagesList = (supa['image_List'] as List)
            .map((e) => e.toString())
            .toList();
      }
    }
    
    return Usermodel(
      password: supa['password'],
      username: supa['username'],
      id: supa['id'] is int ? supa['id'] : (supa['id'] as num?)?.toInt(),
      userId: supa['user_id'],
      imageUrl: supa['image_path'],
      images: imagesList ?? [],
    );
  }

  Map<String, dynamic> toSupabase() {
    final map = {
      "username": username,
      "password": password,
      "image_path": imageUrl,
      "image_List": images,
    };
    // Only include user_id if it's provided (for inserts)
    if (userId != null) {
      map["user_id"] = userId;
    }
    // Don't include id in inserts - it's auto-generated
    return map;
  }
}
