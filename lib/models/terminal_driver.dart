class Terminal_driver {
  int? id;
  String? name;
  String? address;
  String? image;
  String? lat;
  String? lng;
  int? count;


  Terminal_driver({this.id, this.name, this.address, this.image, this.lat, this.lng, this.count});

  factory Terminal_driver.fromJson(Map<String, dynamic> json) {
    return Terminal_driver(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      image: json['image'],
      lat: json['lat'],
      lng: json['lng'],
      count: json['count'],

    );
  }
}
