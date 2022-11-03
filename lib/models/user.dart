class User {
  int? id;
  String? name;
  String? email;
  String? token;
  int? role;

  User({
    this.id,
    this.name,
    this.email,
    this.token,
    this.role
  });

  factory User.fromJson(Map<String, dynamic>json){
    return User(
      id:json['user']['id'],
      name:json['user']['name'],
      email:json['user']['email'],
      role:json['user']['role'],
      token:json['user']['token']
    );
  }
}