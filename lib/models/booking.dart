class Booking {
  int? id;
  String? driver_id;
  String? passenger_id;
  String? terminal_id;
  String? tricycle_id;
  String? passenger_lat;
  String? passenger_lng;
  String? driver_lat;
  String? driver_lng;
  String? passenger_count;
  String? status;
  String? name;
  String? passenger_location;



  Booking({
    this.id, 
    this.driver_id,
    this.passenger_id,
    this.terminal_id,
    this.tricycle_id,
    this.passenger_lat,
    this.passenger_lng,
    this.passenger_count,
    this.passenger_location,
    this.driver_lat,
    this.driver_lng,
    this.status,
    this.name
    });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['booking']['id'],
      driver_id: json['booking']['driver_id'],
      passenger_id: json['booking']['passenger_id'],
      name: json['booking']['name'],
      terminal_id: json['booking']['terminal_id'],
      tricycle_id: json['booking']['tricycle_id'],
      passenger_lat: json['booking']['passenger_lat'],
      passenger_lng: json['booking']['passenger_lng'],
      passenger_count: json['booking']['passenger_count'],
      passenger_location: json['booking']['passenger_location'],
      driver_lat: json['booking']['id'],
      driver_lng: json['booking']['driver_lng'],
      status: json['booking']['status'],
    );
  }
}
