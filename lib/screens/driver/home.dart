// ignore_for_file: avoid_unnecessary_containers

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

import '../../constant.dart';
import '../../models/api.response.dart';
import '../../services/user_service.dart';
import '../login.dart';
import 'register.dart';
import 'package:traykpila/models/terminal.dart';
import '../../models/user.dart';
import '../../constant.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Home> {
  final Completer<GoogleMapController> _controller = Completer();
  bool loading = false;
   User? user;

  List<LatLng> polylineCoordinates = [];
  LocationData? currentLocation;
  
  String currentTerminal = '';
  String username = '';
  String image='';
  String email='';
  


  Future<List<Terminal>> getTerminals() async {
    String token = await getToken();

    final response = await http.post(Uri.parse(terminalShow), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });

    var jsonData = jsonDecode(response.body);
    var jsonArray = jsonData['terminals'];
    List<Terminal> terminals = [];

    for (var jsonTerminal in jsonArray) {
      Terminal terminal = Terminal(
          id: jsonTerminal['id'],
          name: jsonTerminal['name'],
          address: jsonTerminal['address'],
          image: jsonTerminal['image'],
          lat: jsonTerminal['lat'],
          lng: jsonTerminal['lng']);
      terminals.add(terminal);
    }
    return terminals;
  }

  signOut() async {
    await logout();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const Login()),
        (route) => false);
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

  void getUser() async {
    ApiResponse response = await getUserDetail();
    if(response.error == null) {
      setState(() {
        user = response.data as User;
        loading = false;
        username = user!.name ?? '';
        email = user!.email ??'';
        String userimage = user!.image ?? '';
        image = imageBaseUrl+userimage;

      });
    }
    else if(response.error == unauthorized){
      logout().then((value) => {
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>Login()), (route) => false)
      });
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${response.error}')
      ));
    }
  }
  @override
  void initState() {
    loading = true;
    getUser();
    getCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Color.fromRGBO(37, 195, 108, 1.0),
            title: const Text(
              "Dashboard",
              style: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255), fontSize: 16),
            )),
        drawer: NavigationDrawer(),
        body: (Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10.0),
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child:Image.network(
                          image,
                          width: 70,
                          height: 70,
                          fit: BoxFit.cover,
                          )
                      ),
                      Container(
                          padding: const EdgeInsets.only(left: 10.0, top: 30),
                          alignment: Alignment.bottomRight,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                               Text(
                                username,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Color.fromARGB(255, 14, 14, 13)),
                              ),
                              Text(
                                email,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: Color.fromARGB(255, 14, 14, 13)),
                              ),
                              Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: Color.fromARGB(255, 183, 244, 0),
                                  ),
                                  Text('4.5',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                          color:
                                              Color.fromARGB(255, 14, 14, 13))),
                                ],
                              )
                            ],
                          ))
                    ],
                  ),
                  Container(
                      alignment: Alignment.bottomRight,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: const Image(
                              height: 50,
                              width: 50,
                              image: AssetImage('assets/profilepic.png'),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(top: 4),
                            child: const Text(
                              'Active Tricycle - Tric one',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                  fontSize: 10,
                                  color: Color.fromARGB(255, 0, 0, 0)),
                            ),
                          )
                        ],
                      ))
                ],
              ),
            ),
            const Divider(
              height: 1,
              thickness: 1,
              indent: 10,
              endIndent: 10,
              color: Color.fromARGB(255, 65, 220, 135),
            ),
            Container(
              decoration: new BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(.3),
                    blurRadius: 4.0, // soften the shadow
                    spreadRadius: 0.0, //extend the shadow
                    offset: Offset(
                      3.0, // Move to right 10  horizontally
                      3.0, // Move to bottom 10 Vertically
                    ),
                  )
                ],
              ),
              padding: const EdgeInsets.all(10.0),
              child: ListTile(
                  contentPadding:
                      EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 15),
                  horizontalTitleGap: 10.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  tileColor: Color.fromRGBO(37, 195, 108, 1.0),
                  leading: Icon(
                    Icons.map,
                    size: 40.0,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                  trailing: Icon(Icons.keyboard_control_rounded,
                      color: Color.fromARGB(255, 255, 255, 255)),
                  title: Text('Active Terminal',
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 79, 255, 40))),
                  subtitle: Text( currentTerminal ,
                      style: TextStyle(
                          fontSize: 13,
                          color: Color.fromARGB(255, 255, 255, 255))),
                  onTap: () {
                    showModalBottomSheet<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Container(
                                padding: const EdgeInsets.all(20.0),
                                child: const Text("Terminal List",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromARGB(255, 0, 0, 0)))),
                            const Divider(
                              height: 1,
                              thickness: 1,
                              indent: 10,
                              endIndent: 10,
                              color: Color.fromARGB(255, 65, 220, 135),
                            ),
                            Expanded(
                              child: FutureBuilder<List<Terminal>>(
                    future: getTerminals(),
                    builder: (context, snapshot) {
                      if (snapshot.data == null) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        List<Terminal> terminals = snapshot.data!;
                        return ListView.builder(
                            itemCount: terminals.length,
                            itemBuilder: (context, index) {
                              Terminal terminal = terminals[index];
                              String terminalName = terminal.address.toString() + '('+ terminal.name.toString() + ')' ;
                              return  Card(
                                      child: ListTile(
                                          leading: FlutterLogo(),
                                          title:  Text(terminalName),
                                          trailing: Icon(Icons.more_vert),
                                          onTap: () {
                                            setState(() {
                                             currentTerminal = terminalName;
                                            });
                                            Navigator.pop(context);
                                          }),
                                    );
                            });
                      }
                    }),
                            ),
                          ],
                        );
                      },
                    );
                  }),
            ),
            const Divider(
              height: 1,
              thickness: 1,
              indent: 10,
              endIndent: 10,
              color: Color.fromARGB(255, 65, 220, 135),
            ),
            Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 255, 255, 255)),
                  padding: const EdgeInsets.only(
                      top: 10, left: 13, right: 10, bottom: 10),
                  child: Text('Booking List',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 0, 0, 0))),
                )),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(8),
                children: <Widget>[
                  Container(
                    decoration: new BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromARGB(255, 151, 170, 159)
                              .withOpacity(.5),
                          blurRadius: 20.0, // soften the shadow
                          spreadRadius: 0.0, //extend the shadow
                          offset: Offset(
                            5.0, // Move to right 10  horizontally
                            5.0, // Move to bottom 10 Vertically
                          ),
                        )
                      ],
                    ),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: Colors.green.shade300,
                        ),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: ListTile(
                          contentPadding: EdgeInsets.only(
                              top: 15, bottom: 15, left: 35, right: 35),
                          horizontalTitleGap: 10.0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          tileColor: Color.fromARGB(255, 255, 255, 255),
                          title: Container(
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.gps_fixed),
                                    Text(
                                        "  6th St. TODA (GREEN TRICYCLE TERMINAL)",
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: Color.fromARGB(
                                                255, 6, 149, 52)))
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.add_location_alt),
                                    Text(
                                        "  6th St. TODA (GREEN TRICYCLE TERMINAL)",
                                        style: TextStyle(
                                            fontSize: 13,
                                            color:
                                                Color.fromARGB(255, 6, 122, 0)))
                                  ],
                                ),
                                const Divider(
                                  height: 25,
                                  thickness: 1,
                                  indent: 0,
                                  endIndent: 0,
                                  color: Color.fromARGB(255, 65, 220, 135),
                                ),
                                Container(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Jhon lomero",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Color.fromARGB(
                                                  255, 0, 0, 0))),
                                      Text("Count : 3",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0)))
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          onTap: () {/* react to the tile being tapped */}),
                    ),
                  ),
                  Container(
                    decoration: new BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromARGB(255, 151, 170, 159)
                              .withOpacity(.5),
                          blurRadius: 20.0, // soften the shadow
                          spreadRadius: 0.0, //extend the shadow
                          offset: Offset(
                            5.0, // Move to right 10  horizontally
                            5.0, // Move to bottom 10 Vertically
                          ),
                        )
                      ],
                    ),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: Colors.green.shade300,
                        ),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: ListTile(
                          contentPadding: EdgeInsets.only(
                              top: 15, bottom: 15, left: 35, right: 35),
                          horizontalTitleGap: 10.0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          tileColor: Color.fromARGB(255, 255, 255, 255),
                          title: Container(
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.gps_fixed),
                                    Text(
                                        "  6th St. TODA (GREEN TRICYCLE TERMINAL)",
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: Color.fromARGB(
                                                255, 6, 149, 52)))
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.add_location_alt),
                                    Text(
                                        "  6th St. TODA (GREEN TRICYCLE TERMINAL)",
                                        style: TextStyle(
                                            fontSize: 13,
                                            color:
                                                Color.fromARGB(255, 6, 122, 0)))
                                  ],
                                ),
                                const Divider(
                                  height: 25,
                                  thickness: 1,
                                  indent: 0,
                                  endIndent: 0,
                                  color: Color.fromARGB(255, 65, 220, 135),
                                ),
                                Container(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Jhon lomero",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Color.fromARGB(
                                                  255, 0, 0, 0))),
                                      Text("Count : 3",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0)))
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          onTap: () {/* react to the tile being tapped */}),
                    ),
                  ),
                  Container(
                    decoration: new BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromARGB(255, 151, 170, 159)
                              .withOpacity(.5),
                          blurRadius: 20.0, // soften the shadow
                          spreadRadius: 0.0, //extend the shadow
                          offset: Offset(
                            5.0, // Move to right 10  horizontally
                            5.0, // Move to bottom 10 Vertically
                          ),
                        )
                      ],
                    ),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: Colors.green.shade300,
                        ),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: ListTile(
                          contentPadding: EdgeInsets.only(
                              top: 15, bottom: 15, left: 35, right: 35),
                          horizontalTitleGap: 10.0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          tileColor: Color.fromARGB(255, 255, 255, 255),
                          title: Container(
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.gps_fixed),
                                    Text(
                                        "  6th St. TODA (GREEN TRICYCLE TERMINAL)",
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: Color.fromARGB(
                                                255, 6, 149, 52)))
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.add_location_alt),
                                    Text(
                                        "  6th St. TODA (GREEN TRICYCLE TERMINAL)",
                                        style: TextStyle(
                                            fontSize: 13,
                                            color:
                                                Color.fromARGB(255, 6, 122, 0)))
                                  ],
                                ),
                                const Divider(
                                  height: 25,
                                  thickness: 1,
                                  indent: 0,
                                  endIndent: 0,
                                  color: Color.fromARGB(255, 65, 220, 135),
                                ),
                                Container(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Jhon lomero",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Color.fromARGB(
                                                  255, 0, 0, 0))),
                                      Text("Count : 3",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0)))
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          onTap: () {/* react to the tile being tapped */}),
                    ),
                  ),
                  Container(
                    decoration: new BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromARGB(255, 151, 170, 159)
                              .withOpacity(.5),
                          blurRadius: 20.0, // soften the shadow
                          spreadRadius: 0.0, //extend the shadow
                          offset: Offset(
                            5.0, // Move to right 10  horizontally
                            5.0, // Move to bottom 10 Vertically
                          ),
                        )
                      ],
                    ),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: Colors.green.shade300,
                        ),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: ListTile(
                          contentPadding: EdgeInsets.only(
                              top: 15, bottom: 15, left: 35, right: 35),
                          horizontalTitleGap: 10.0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          tileColor: Color.fromARGB(255, 255, 255, 255),
                          title: Container(
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.gps_fixed),
                                    Text(
                                        "  6th St. TODA (GREEN TRICYCLE TERMINAL)",
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: Color.fromARGB(
                                                255, 6, 149, 52)))
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.add_location_alt),
                                    Text(
                                        "  6th St. TODA (GREEN TRICYCLE TERMINAL)",
                                        style: TextStyle(
                                            fontSize: 13,
                                            color:
                                                Color.fromARGB(255, 6, 122, 0)))
                                  ],
                                ),
                                const Divider(
                                  height: 25,
                                  thickness: 1,
                                  indent: 0,
                                  endIndent: 0,
                                  color: Color.fromARGB(255, 65, 220, 135),
                                ),
                                Container(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Jhon lomero",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Color.fromARGB(
                                                  255, 0, 0, 0))),
                                      Text("Count : 3",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0)))
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          onTap: () {/* react to the tile being tapped */}),
                    ),
                  ),
                  Container(
                    decoration: new BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromARGB(255, 151, 170, 159)
                              .withOpacity(.5),
                          blurRadius: 20.0, // soften the shadow
                          spreadRadius: 0.0, //extend the shadow
                          offset: Offset(
                            5.0, // Move to right 10  horizontally
                            5.0, // Move to bottom 10 Vertically
                          ),
                        )
                      ],
                    ),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: Colors.green.shade300,
                        ),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: ListTile(
                          contentPadding: EdgeInsets.only(
                              top: 15, bottom: 15, left: 35, right: 35),
                          horizontalTitleGap: 10.0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          tileColor: Color.fromARGB(255, 255, 255, 255),
                          title: Container(
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.gps_fixed),
                                    Text(
                                        "  6th St. TODA (GREEN TRICYCLE TERMINAL)",
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: Color.fromARGB(
                                                255, 6, 149, 52)))
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.add_location_alt),
                                    Text(
                                        "  6th St. TODA (GREEN TRICYCLE TERMINAL)",
                                        style: TextStyle(
                                            fontSize: 13,
                                            color:
                                                Color.fromARGB(255, 6, 122, 0)))
                                  ],
                                ),
                                const Divider(
                                  height: 25,
                                  thickness: 1,
                                  indent: 0,
                                  endIndent: 0,
                                  color: Color.fromARGB(255, 65, 220, 135),
                                ),
                                Container(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Jhon lomero",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Color.fromARGB(
                                                  255, 0, 0, 0))),
                                      Text("Count : 3",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0)))
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          onTap: () {/* react to the tile being tapped */}),
                    ),
                  ),
                  Container(
                    decoration: new BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromARGB(255, 151, 170, 159)
                              .withOpacity(.5),
                          blurRadius: 20.0, // soften the shadow
                          spreadRadius: 0.0, //extend the shadow
                          offset: Offset(
                            5.0, // Move to right 10  horizontally
                            5.0, // Move to bottom 10 Vertically
                          ),
                        )
                      ],
                    ),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: Colors.green.shade300,
                        ),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: ListTile(
                          contentPadding: EdgeInsets.only(
                              top: 15, bottom: 15, left: 35, right: 35),
                          horizontalTitleGap: 10.0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          tileColor: Color.fromARGB(255, 255, 255, 255),
                          title: Container(
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.gps_fixed),
                                    Text(
                                        "  6th St. TODA (GREEN TRICYCLE TERMINAL)",
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: Color.fromARGB(
                                                255, 6, 149, 52)))
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.add_location_alt),
                                    Text(
                                        "  6th St. TODA (GREEN TRICYCLE TERMINAL)",
                                        style: TextStyle(
                                            fontSize: 13,
                                            color:
                                                Color.fromARGB(255, 6, 122, 0)))
                                  ],
                                ),
                                const Divider(
                                  height: 25,
                                  thickness: 1,
                                  indent: 0,
                                  endIndent: 0,
                                  color: Color.fromARGB(255, 65, 220, 135),
                                ),
                                Container(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Jhon lomero",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Color.fromARGB(
                                                  255, 0, 0, 0))),
                                      Text("Count : 3",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0)))
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          onTap: () {/* react to the tile being tapped */}),
                    ),
                  ),
                  Container(
                    decoration: new BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromARGB(255, 151, 170, 159)
                              .withOpacity(.5),
                          blurRadius: 20.0, // soften the shadow
                          spreadRadius: 0.0, //extend the shadow
                          offset: Offset(
                            5.0, // Move to right 10  horizontally
                            5.0, // Move to bottom 10 Vertically
                          ),
                        )
                      ],
                    ),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: Colors.green.shade300,
                        ),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: ListTile(
                          contentPadding: EdgeInsets.only(
                              top: 15, bottom: 15, left: 35, right: 35),
                          horizontalTitleGap: 10.0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          tileColor: Color.fromARGB(255, 255, 255, 255),
                          title: Container(
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.gps_fixed),
                                    Text(
                                        "  6th St. TODA (GREEN TRICYCLE TERMINAL)",
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: Color.fromARGB(
                                                255, 6, 149, 52)))
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.add_location_alt),
                                    Text(
                                        "  6th St. TODA (GREEN TRICYCLE TERMINAL)",
                                        style: TextStyle(
                                            fontSize: 13,
                                            color:
                                                Color.fromARGB(255, 6, 122, 0)))
                                  ],
                                ),
                                const Divider(
                                  height: 25,
                                  thickness: 1,
                                  indent: 0,
                                  endIndent: 0,
                                  color: Color.fromARGB(255, 65, 220, 135),
                                ),
                                Container(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Jhon lomero",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Color.fromARGB(
                                                  255, 0, 0, 0))),
                                      Text("Count : 3",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0)))
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          onTap: () {/* react to the tile being tapped */}),
                    ),
                  ),
                  Container(
                    decoration: new BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromARGB(255, 151, 170, 159)
                              .withOpacity(.5),
                          blurRadius: 20.0, // soften the shadow
                          spreadRadius: 0.0, //extend the shadow
                          offset: Offset(
                            5.0, // Move to right 10  horizontally
                            5.0, // Move to bottom 10 Vertically
                          ),
                        )
                      ],
                    ),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: Colors.green.shade300,
                        ),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: ListTile(
                          contentPadding: EdgeInsets.only(
                              top: 15, bottom: 15, left: 35, right: 35),
                          horizontalTitleGap: 10.0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          tileColor: Color.fromARGB(255, 255, 255, 255),
                          title: Container(
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.gps_fixed),
                                    Text(
                                        "  6th St. TODA (GREEN TRICYCLE TERMINAL)",
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: Color.fromARGB(
                                                255, 6, 149, 52)))
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.add_location_alt),
                                    Text(
                                        "  6th St. TODA (GREEN TRICYCLE TERMINAL)",
                                        style: TextStyle(
                                            fontSize: 13,
                                            color:
                                                Color.fromARGB(255, 6, 122, 0)))
                                  ],
                                ),
                                const Divider(
                                  height: 25,
                                  thickness: 1,
                                  indent: 0,
                                  endIndent: 0,
                                  color: Color.fromARGB(255, 65, 220, 135),
                                ),
                                Container(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Jhon lomero",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Color.fromARGB(
                                                  255, 0, 0, 0))),
                                      Text("Count : 3",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0)))
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          onTap: () {/* react to the tile being tapped */}),
                    ),
                  ),
                  Container(
                    decoration: new BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromARGB(255, 151, 170, 159)
                              .withOpacity(.5),
                          blurRadius: 20.0, // soften the shadow
                          spreadRadius: 0.0, //extend the shadow
                          offset: Offset(
                            5.0, // Move to right 10  horizontally
                            5.0, // Move to bottom 10 Vertically
                          ),
                        )
                      ],
                    ),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: Colors.green.shade300,
                        ),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: ListTile(
                          contentPadding: EdgeInsets.only(
                              top: 15, bottom: 15, left: 35, right: 35),
                          horizontalTitleGap: 10.0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          tileColor: Color.fromARGB(255, 255, 255, 255),
                          title: Container(
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.gps_fixed),
                                    Text(
                                        "  6th St. TODA (GREEN TRICYCLE TERMINAL)",
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: Color.fromARGB(
                                                255, 6, 149, 52)))
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.add_location_alt),
                                    Text(
                                        "  6th St. TODA (GREEN TRICYCLE TERMINAL)",
                                        style: TextStyle(
                                            fontSize: 13,
                                            color:
                                                Color.fromARGB(255, 6, 122, 0)))
                                  ],
                                ),
                                const Divider(
                                  height: 25,
                                  thickness: 1,
                                  indent: 0,
                                  endIndent: 0,
                                  color: Color.fromARGB(255, 65, 220, 135),
                                ),
                                Container(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Jhon lomero",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Color.fromARGB(
                                                  255, 0, 0, 0))),
                                      Text("Count : 3",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0)))
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          onTap: () {/* react to the tile being tapped */}),
                    ),
                  ),
                  Container(
                    decoration: new BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromARGB(255, 151, 170, 159)
                              .withOpacity(.5),
                          blurRadius: 20.0, // soften the shadow
                          spreadRadius: 0.0, //extend the shadow
                          offset: Offset(
                            5.0, // Move to right 10  horizontally
                            5.0, // Move to bottom 10 Vertically
                          ),
                        )
                      ],
                    ),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: Colors.green.shade300,
                        ),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: ListTile(
                          contentPadding: EdgeInsets.only(
                              top: 15, bottom: 15, left: 35, right: 35),
                          horizontalTitleGap: 10.0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          tileColor: Color.fromARGB(255, 255, 255, 255),
                          title: Container(
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.gps_fixed),
                                    Text(
                                        "  6th St. TODA (GREEN TRICYCLE TERMINAL)",
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: Color.fromARGB(
                                                255, 6, 149, 52)))
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.add_location_alt),
                                    Text(
                                        "  6th St. TODA (GREEN TRICYCLE TERMINAL)",
                                        style: TextStyle(
                                            fontSize: 13,
                                            color:
                                                Color.fromARGB(255, 6, 122, 0)))
                                  ],
                                ),
                                const Divider(
                                  height: 25,
                                  thickness: 1,
                                  indent: 0,
                                  endIndent: 0,
                                  color: Color.fromARGB(255, 65, 220, 135),
                                ),
                                Container(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Jhon lomero",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Color.fromARGB(
                                                  255, 0, 0, 0))),
                                      Text("Count : 3",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0)))
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          onTap: () {/* react to the tile being tapped */}),
                    ),
                  ),
                  Container(
                    decoration: new BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromARGB(255, 151, 170, 159)
                              .withOpacity(.5),
                          blurRadius: 20.0, // soften the shadow
                          spreadRadius: 0.0, //extend the shadow
                          offset: Offset(
                            5.0, // Move to right 10  horizontally
                            5.0, // Move to bottom 10 Vertically
                          ),
                        )
                      ],
                    ),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: Colors.green.shade300,
                        ),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: ListTile(
                          contentPadding: EdgeInsets.only(
                              top: 15, bottom: 15, left: 35, right: 35),
                          horizontalTitleGap: 10.0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          tileColor: Color.fromARGB(255, 255, 255, 255),
                          title: Container(
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.gps_fixed),
                                    Text(
                                        "  6th St. TODA (GREEN TRICYCLE TERMINAL)",
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: Color.fromARGB(
                                                255, 6, 149, 52)))
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.add_location_alt),
                                    Text(
                                        "  6th St. TODA (GREEN TRICYCLE TERMINAL)",
                                        style: TextStyle(
                                            fontSize: 13,
                                            color:
                                                Color.fromARGB(255, 6, 122, 0)))
                                  ],
                                ),
                                const Divider(
                                  height: 25,
                                  thickness: 1,
                                  indent: 0,
                                  endIndent: 0,
                                  color: Color.fromARGB(255, 65, 220, 135),
                                ),
                                Container(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Jhon lomero",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Color.fromARGB(
                                                  255, 0, 0, 0))),
                                      Text("Count : 3",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0)))
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          onTap: () {/* react to the tile being tapped */}),
                    ),
                  ),
                ],
              ),
            )
          ],
        )));
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
                  leading: const Icon(Icons.star),
                  title: const Text('Vihicle'),
                  onTap: () async {
                    await logout();
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => Register()),
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
