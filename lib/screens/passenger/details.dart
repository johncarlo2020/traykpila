import 'dart:convert';

import 'package:flutter/material.dart';
import '../home.dart';
import '../../models/booking.dart';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:location/location.dart';


import 'package:traykpila/constant.dart';
import 'package:http/http.dart' as http;
import 'package:traykpila/constant.dart';


class Details extends StatefulWidget {
  String id;
  Details(this.id);

  @override
  State<Details> createState() {
    return _HomePageWidgetState(this.id);
  } 
}

class _HomePageWidgetState extends State<Details> {
  String id;
  _HomePageWidgetState(this.id);
  final _unfocusNode = FocusNode();
  final scaffoldKey = GlobalKey<ScaffoldState>();

    Booking? booking;
  late String passenger_location='';
  late String passenger_count='';
  late String passenger_name='';
  late String driver_lat='';
  late String driver_lng='';
  late String passenger_lat='';
  late String passenger_lng='';

  List<LatLng> polylineCoordinates = [];

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
        print(driver_lat);
      });
    }
    return booking;
  }


   @override
    void initState() {
    booking_Details();
    super.initState();
  }

  @override
  void dispose() {
    _unfocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(37, 195, 108, 1.0),
        leading: IconButton(
          onPressed: () async {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const Home()),
                (route) => false);
          },
          style: TextButton.styleFrom(
            primary: Color.fromARGB(255, 255, 255, 255),
            // Background Color
          ),
          icon: Icon(
            Icons.arrow_back,
            size: 24.0,
          ),
        ),
        title: const Text(
          "Booking Details",
          style: TextStyle(
              color: Color.fromARGB(255, 255, 255, 255), fontSize: 16),
        ),
        actions: [],
        centerTitle: false,
        elevation: 2,
      ),
      body: Column(
        children: [
          Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      width: 100,
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
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
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                height: 199.1,
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Align(
                              alignment: AlignmentDirectional(0, 0),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    40, 40, 40, 10),
                                child: Material(
                                  color: Colors.transparent,
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(1),
                                  ),
                                  child: Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(1),
                                      border: Border.all(
                                        color: Color(0xFF00AF00),
                                        width: 3,
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.location_history_sharp,
                                      color: Color(0xFF00AF00),
                                      size: 60,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              'Driver',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                color: Color(0xFF00AC00),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Align(
                            alignment: AlignmentDirectional(0, 0),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  40, 40, 40, 10),
                              child: Material(
                                color: Colors.transparent,
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(1),
                                ),
                                child: Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(1),
                                    border: Border.all(
                                      color: Color(0xFF00AF00),
                                      width: 3,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.location_history_sharp,
                                    color: Color(0xFF00AF00),
                                    size: 60,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Text(
                            'Vehicle',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Color(0xFF00AF00),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(50, 0, 50, 50),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(2, 5, 2, 2),
                        child: Text(
                          'Name: Mang jose',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Color(0xFF00AF00),
                            fontSize: 17,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(2, 5, 2, 2),
                        child: Text(
                          'Body #: 221b',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Color(0xFF00AC00),
                            fontSize: 17,
                          ),
                        ),
                      ),
                      Text(
                        'Terminal: 6th St. TODA (GREEN TRICYCLE TERMINAL)',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Color(0xFF00AC00),
                          fontSize: 17,
                        ),
                      ),
                      Text(
                        'Phone: 09232324356',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Color(0xFF00AC00),
                          fontSize: 17,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 120, vertical: 15),
                ),
                label: const Text('Message'),
                icon: const Icon(Icons.message),
              )
            ],
          ),
        ],
      ),
    );
  }
}
