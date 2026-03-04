class Usermodel {
  String? username;
  String? password;
  int? id; // Database primary key (int8)
  String? userId; // Foreign key to auth.users (uuid)

  Usermodel({
    this.id,
    this.userId,
    required this.password,
    required this.username,
  });

  factory Usermodel.fromSupaBase(Map<String, dynamic> supa) {
    return Usermodel(
      password: supa['password'],
      username: supa['username'],
      id: supa['id'] is int ? supa['id'] : (supa['id'] as num?)?.toInt(),
      userId: supa['user_id'],
    );
  }

  Map<String, dynamic> toSupabase() {
    final map = {
      "username": username,
      "password": password,
    };
    // Only include user_id if it's provided (for inserts)
    if (userId != null) {
      map["user_id"] = userId;
    }
    // Don't include id in inserts - it's auto-generated
    return map;
  }
}
