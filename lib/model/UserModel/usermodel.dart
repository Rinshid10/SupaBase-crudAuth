class Usermodel {
  String? username;
  String? password;
  int? id;

  Usermodel({this.id, required this.password, required this.username});
  factory Usermodel.fromSupaBase(Map<String, dynamic> supa) {
    return Usermodel(
        password: supa['password'], username: supa['username'], id: supa['id']);
  }
  Map<String, dynamic> toSupabase() {
    return {
      "username": username,
      "password": password,
    };
  }
}
