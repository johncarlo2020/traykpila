class Terminal {
  int? id;
  String? name;
  String? address;
  String? image;
  String? lat;
  String? lng;

  Terminal({this.id, this.name, this.address, this.image, this.lat, this.lng});

  factory Terminal.fromJson(Map<String, dynamic> json) {
    return Terminal(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      image: json['address'],
      lat: json['lat'],
      lng: json['lng'],
    );
  }
}
