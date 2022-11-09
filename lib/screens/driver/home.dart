import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../../constant.dart';
import '../../services/user_service.dart';
import '../login.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Home> {
  final Completer<GoogleMapController> _controller = Completer();
  bool loading = false;

  List<LatLng> polylineCoordinates = [];
  LocationData? currentLocation;

  signOut() async {
    await logout();
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Login()), (route) => false);
  }

  void getCurrentLocation() {
    Location location = Location();

    location.getLocation().then(
      (location) {
        setState(() {
          loading = false;
        });
        currentLocation = location;
      },
    );
  }

  @override
  void initState() {
    loading = true;
    getCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text(
          "Driver Current Location",
          style: TextStyle(color: Colors.black, fontSize: 16),
        )),
         floatingActionButton: FloatingActionButton(
        onPressed: () {
          signOut();
        },
        child: Icon(Icons.logout_rounded),
        backgroundColor: Colors.green,
      ),
        body: loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : GoogleMap(
                initialCameraPosition: CameraPosition(
                    target: (LatLng(currentLocation!.latitude!,
                        currentLocation!.longitude!)),
                    zoom: 17),
                markers: {
                  Marker(
                      markerId: const MarkerId("currentLocation"),
                      position: LatLng(currentLocation!.latitude!,
                          currentLocation!.longitude!)),
                },
              ));
  }
}
