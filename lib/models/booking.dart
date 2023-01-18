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
      id: json['id'],
      driver_id: json['driver_id'],
      passenger_id: json['passenger_id'],
      name: json['name'],
      terminal_id: json['terminal_id'],
      tricycle_id: json['tricycle_id'],
      passenger_lat: json['passenger_lat'],
      passenger_lng: json['passenger_lng'],
      passenger_count: json['passenger_count'],
      passenger_location: json['passenger_location'],
      driver_lat: json['id'],
      driver_lng: json['driver_lng'],
      status: json['status'],
    );
  }
}
