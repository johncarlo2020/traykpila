import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../constant.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Home> {
  final Completer<GoogleMapController> _controller = Completer();
  static const LatLng sourceLocation= LatLng(14.9231306, 120.2019086);
  static const LatLng destinationLocation= LatLng(14.9265898, 120.2024622);
  bool loading = false;

  List<LatLng> polylineCoordinates = [];
  LocationData? currentLocation;

  void getCurrentLocation(){
    Location location = Location();

    location.getLocation().then(
      
      (location) {
        loading=false;
        currentLocation=location;
      },
      );
  }

  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      google_api_key, 
      PointLatLng(sourceLocation.latitude, sourceLocation.latitude), 
      PointLatLng(destinationLocation.latitude, destinationLocation.longitude)
      );

      if (result.points.isNotEmpty){
        result.points.forEach(
          (PointLatLng point) => polylineCoordinates.add(
            LatLng(point.latitude, point.longitude)
            ),
          );
      setState(() {});
      }
  }

  @override
  void initState(){
    loading = true;
    getCurrentLocation();
    getPolyPoints();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text(
          "Current Location",
          style: TextStyle(color:Colors.black, fontSize: 16),
        )
      ),
      body: loading? Center(child: CircularProgressIndicator(),)
        
        :GoogleMap(
        initialCameraPosition: 
          CameraPosition(target: (LatLng(currentLocation!.latitude!,currentLocation!.longitude!)), zoom:  17),
          polylines: {
            Polyline(
            polylineId: PolylineId("route"),
            points:polylineCoordinates,
            )
          },
          markers: {
            Marker(
              markerId: const MarkerId("currentLocation"),
              position:LatLng(
                currentLocation!.latitude!, currentLocation!.longitude!
                )
              ),
            
          },
        )
    );
  }
}