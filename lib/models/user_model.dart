class UserModel {
  String id;
  String name;
  String email;
  String createdAt;
  String photoURL;

  UserModel({
    this.id = "",
    required this.name,
    required this.email,
    required this.createdAt,
    this.photoURL = "",
  });

  UserModel.fromJson(Map<String, dynamic> json)
      : this(
    id: json['id'],
    name: json['name'],
    email: json['email'],
    createdAt: json['createdAt'],
    photoURL: json['photoURL'] ?? "",
  );

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "createdAt": createdAt,
      "photoURL": photoURL,
    };
  }
}