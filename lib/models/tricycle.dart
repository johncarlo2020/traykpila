class Tricycle {
  int? id;
  String? name;
  String? body_number;
  String? image;
  String? plate_number;
  String? max_passenger;
  int? user_id;



  Tricycle({this.id, this.name, this.body_number, this.image, this.plate_number, this.max_passenger,this.user_id});

  factory Tricycle.fromJson(Map<String, dynamic> json) {
    return Tricycle(
      id: json['id'],
      name: json['name'],
      body_number: json['body_number'],
      image: json['image'],
      plate_number: json['plate_number'],
      max_passenger: json['max_passenger'],
      user_id: json['user_id'],

    );
  }
}
