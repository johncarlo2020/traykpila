import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:location/location.dart';

import 'package:traykpila/constant.dart';
import 'package:http/http.dart' as http;
import 'package:traykpila/constant.dart';

import '../../models/api.response.dart';
import '../../models/booking.dart';
import '../../services/user_service.dart';

class BookedDetails extends StatefulWidget {
  String id;
  BookedDetails(this.id);
  @override
  State<BookedDetails> createState(){
    return _BookedDetailsState(this.id);
  } 
}

class _BookedDetailsState extends State<BookedDetails> {
  String id;
  _BookedDetailsState(this.id);

  Booking? booking;
  late String passenger_location='';
  late String passenger_count='';
  late String passenger_name='';
  late String driver_lat='';
  late String driver_lng='';
  late String passenger_lat='';
  late String passenger_lng='';

  List<LatLng> polylineCoordinates = [];




   @override
  void initState() {
    booking_Details();
    super.initState();
  }

  Future <List<Booking>> booking_Details() async {
    final response = await http.post(Uri.parse(bookingDetails), headers: {
      'Accept': 'application/json',
    },body:{
      'id':id
    });

    var jsonData = jsonDecode(response.body);
    var jsonArray = jsonData['booking'];
    List<Booking> booking = [];

    for (var jsonBooking in jsonArray) {
      setState(() {
        passenger_location=jsonBooking['passenger_location'];
        passenger_count=jsonBooking['passenger_count'];
        passenger_name=jsonBooking['name'];
        driver_lat=jsonBooking['driver_lat'];
        driver_lng=jsonBooking['driver_lng'];
        passenger_lat=jsonBooking['passenger_lat'];
        passenger_lng=jsonBooking['passenger_lng'];
        print(passenger_lat);


      });
    }
    return booking;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(37, 195, 108, 1.0),
        title: const Text(
          "Booking Details",
          style: TextStyle(
              color: Color.fromARGB(255, 255, 255, 255), fontSize: 16),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration:
                  const BoxDecoration(color: Color.fromRGBO(37, 195, 108, 1.0)),
              width: double.infinity,
              height: MediaQuery.of(context).size.width * 0.90,
              child: GoogleMap(
        initialCameraPosition: 
          CameraPosition(target: (LatLng(double.parse(driver_lat),double.parse(driver_lng))), zoom:  17),
          polylines: {
            Polyline(
            polylineId: PolylineId("route"),
            points:polylineCoordinates,
            )
          },
          markers: {
            Marker(
              markerId: const MarkerId("currentLocation"),
              position:LatLng(double.parse(driver_lat),double.parse(driver_lng))
              ),
            
            // Marker(
            //   markerId: MarkerId("source"),
            //   position:sourceLocation,
            //   ),
            //   Marker(
            //   markerId: MarkerId("destiantion"),
            //   position:destinationLocation,
            //   ),
          },
        ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Expanded(
                child: PhysicalModel(
                  color: Colors.white,
                  elevation: 4,
                  shadowColor: Color.fromARGB(169, 131, 243, 135),
                  borderRadius: BorderRadius.circular(6),
                  child: ListTile(
                    leading: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image(
                          image: AssetImage('assets/pasenger.png'),
                          width: 70,
                          height: 70,
                          fit: BoxFit.cover,
                        )),
                    title: Text(
                      passenger_name,
                      style: TextStyle(
                        fontSize: 20,
                        //COLOR DEL TEXTO TITULO
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                    subtitle: Flexible(
                      child: Text(passenger_location,
                          style: TextStyle(
                            fontSize: 11,
                            //COLOR DEL TEXTO TITULO
                            color: Color.fromARGB(255, 0, 151, 76),
                          )),
                    ),
                    trailing: Text(
                      passenger_count,
                      style: TextStyle(
                        fontSize: 30,
                        //COLOR DEL TEXTO TITULO
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 10, right: 10),
              height: MediaQuery.of(context).size.width * 0.50,
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green,
                        onPrimary: Colors.white,
                        shadowColor: Colors.greenAccent,
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6.0)),
                        minimumSize: Size(100, 40), //////// HERE
                      ),
                      onPressed: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.message_outlined),
                          Text('Message')
                        ],
                      ),
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
