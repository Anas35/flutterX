class XUser {
  final String id;
  final String email;
  final String name;
  final String userName;
  final String profileUrl;

  const XUser({
    required this.profileUrl,
    required this.id,
    required this.email,
    required this.name,
    required this.userName,
  });

  Map<String, Object> toJson() {
    return {
      "uid": id,
      "email": email,
      "userName": userName,
      "name": name,
      "profileUrl": profileUrl,
    };
  }

  factory XUser.fromJson(Map<String, Object?> json) {
    return XUser(
      profileUrl: json['profileUrl'] as String,
      id: json['uid'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      userName: json['userName'] as String? ?? ""
    );
  }

  XUser copyWith({String? profileUrl, String? id}) {
    return XUser(
      profileUrl: profileUrl ?? this.profileUrl,
      id: id ?? this.id,
      email: email,
      name: name,
      userName: userName,
    );
  }
}
