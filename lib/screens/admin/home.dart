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

  int _selectedIndex = 0;

  signOut() async {
    await logout();
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Login()), (route) => false);
  }

  void _onItemTapped(int index) {
  setState(() {
    _selectedIndex = index;
  });
}

  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
      List<Widget> _pages = <Widget>[
      Dashboard(),
      Icon(
        Icons.camera,
        size: 150,
      ),
      Icon(
        Icons.chat,
        size: 150,
      ),
    ];
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
        //IconButton
          IconButton(
            icon: const Icon(Icons.account_circle),
            tooltip: 'Setting Icon',
            onPressed: () {},
          ), //IconButton
        ], //<Widget>[]
        backgroundColor: Colors.greenAccent[400],
        elevation: 50.0,
        leading: const Image(
                image: AssetImage('assets/logoforwhite.png'),
                width: 150,
                height: 150,
              ),
      ),
       floatingActionButton: FloatingActionButton(
        onPressed: () {
          signOut();
        },
        child: Icon(Icons.logout_rounded),
        backgroundColor: Colors.green,
      ), //AppBar
        body: Center(
          child: _pages.elementAt(_selectedIndex), //New
        ),
       bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.greenAccent[400],
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Colors.white
              ),
            label: 'Home',
            
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.gps_fixed_sharp,
              color: Colors.white
              ),
            label: 'Add Terminal',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.list,
              color: Colors.white
              ),
            label: 'Terminal List'
          ),
          
        ],
        currentIndex: _selectedIndex, //New
          onTap: _onItemTapped, 
      ),

    );
  }
}
