class User {
  int? id;
  String? name;
  String? email;
  String? token;
  String? role;
  String? address;

  User({
    this.id,
    this.name,
    this.email,
    this.token,
    this.role,
    this.address
  });

  factory User.fromJson(Map<String, dynamic>json){
    return User(
      id:json['user']['id'],
      name:json['user']['name'],
      email:json['user']['email'],
      token:json['user']['token'],
     address:json['user']['address'],
     role:json['user']['role'],


    );
  }
}