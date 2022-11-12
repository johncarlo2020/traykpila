import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../../constant.dart';
import '../../models/api.response.dart';
import '../../services/user_service.dart';
import '../login.dart';
import '../../models/terminal.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Home> {
  final Completer<GoogleMapController> _controller = Completer();
  late String terminalCount = '';
  late String userCount = '';
  late String driverCount = '';
  var sreenName = '';

  bool loading = false;
  // ignore: non_constant_identifier_names

  List<LatLng> polylineCoordinates = [];
  LocationData? currentLocation;

  int _selectedIndex = 0;

  // signOut() async {
  //   await logout();
  //   Navigator.of(context).pushAndRemoveUntil(
  //       MaterialPageRoute(builder: (context) => Login()), (route) => false);
  // }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        sreenName = 'Dashboard';
        break;

      case 1:
        sreenName = 'Add Terminal';
        break;

      case 2:
        sreenName = 'Terminal List';
        break;
    }
  }

  void _Count() async {
    int tcount = await getTerminalCount();
    int ucount = await getUserCount();
    int dcount = await getDriverCount();

    setState(() {
      terminalCount = tcount.toString();
      userCount = ucount.toString();
      driverCount = dcount.toString();
    });
  }

  @override
  void initState() {
    _Count();
    super.initState();
  }

  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers

    List<Widget> _pages = <Widget>[
      Dashboard(terminalCount, userCount, driverCount),
      AddTerminal(),
      Icon(
        Icons.chat,
        size: 150,
      ),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(sreenName),
        //<Widget>[]
        backgroundColor: Color.fromARGB(255, 72, 206, 133),
      ),
      drawer: NavigationDrawer(),
      //AppBar
      body: Center(
        child: _pages.elementAt(_selectedIndex), //New
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color.fromARGB(255, 72, 206, 133),
        selectedItemColor: Color.fromARGB(255, 255, 255, 255),
        unselectedItemColor: Colors.white,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 35.0),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_location_alt_outlined, size: 35.0),
            label: 'Add Terminal',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.list, size: 35.0), label: 'Terminal List'),
        ],
        currentIndex: _selectedIndex, //New
        onTap: _onItemTapped,
      ),
    );
  }
}

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Drawer(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 60.0),
          child: Wrap(
            runSpacing: 16,
            children: <Widget>[
              ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Log-out'),
                  onTap: () async {
                    await logout();
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => Login()),
                        (route) => false);
                  }),
              ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Log-out'),
                  onTap: () async {
                    await logout();
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => Login()),
                        (route) => false);
                  }),
              ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Log-out'),
                  onTap: () async {
                    await logout();
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => Login()),
                        (route) => false);
                  }),
              ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Log-out'),
                  onTap: () async {
                    await logout();
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => Login()),
                        (route) => false);
                  }),
            ],
          ),
        ),
      ));
}
