import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:traykpila/screens/passenger/details.dart' as Details;

import '../../constant.dart';
import '../../services/user_service.dart';
import 'login.dart';
import 'package:traykpila/models/terminal.dart';

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
        MaterialPageRoute(builder: (context) => Login()), (route) => false);
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
          backgroundColor: Color.fromRGBO(37, 195, 108, 1.0),
          title: const Text(
            "Dashboard",
            style: TextStyle(
                color: Color.fromARGB(255, 255, 255, 255), fontSize: 16),
          ),
          centerTitle: false,
          elevation: 2,
        ),
        drawer: NavigationDrawer(),
        body: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: (Column(
              children: [
                // Generated code for this Row Widget...
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
                      child: Text(
                        'Need a Tricycle?\nBook Now!',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Color(0xFF069E1C),
                          fontSize: 25,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(30, 0, 0, 0),
                      child: Image.asset(
                        'assets/trayklogo.png',
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),

                TextFormField(
                  validator: (val) => val!.isEmpty ? 'Invalid Name' : null,
                  // ignore: prefer_const_constructors
                  decoration: InputDecoration(
                      isDense: true,
                      labelText: 'Search Terminal',
                      border: InputBorder.none,
                      filled: true,
                      fillColor: const Color.fromRGBO(229, 255, 238, 1.0),
                      prefixIcon: const Icon(
                        Icons.search_outlined,
                        size: 30,
                      )),
                ),
                const Divider(
                  height: 20,
                  thickness: 2,
                  indent: 0,
                  endIndent: 0,
                  color: Color.fromARGB(255, 49, 241, 129),
                ),
                Expanded(
                  child: FutureBuilder<List<Terminal>>(
                      future: getTerminals(),
                      builder: (context, snapshot) {
                        if (snapshot.data == null) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          List<Terminal> terminals = snapshot.data!;
                          return ListView.builder(
                              itemCount: terminals.length,
                              itemBuilder: (context, index) {
                                Terminal terminal = terminals[index];
                                return Card(
                                  child: ListTile(
                                      leading: Icon(
                                        Icons.map,
                                        size: 30.0,
                                        color:
                                            Color.fromARGB(255, 72, 206, 133),
                                      ),
                                      title: Text(terminal.name.toString()),
                                      subtitle:
                                          Text(terminal.address.toString()),
                                      trailing: Text('Book'),
                                      onTap: () {
                                        Navigator.of(context)
                                            .pushAndRemoveUntil(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        Details.Details()),
                                                (route) => false);
                                      }
                                      //  onTap: ,
                                      ),
                                );
                              });
                        }
                      }),
                )
              ],
            )),
          ),
        ));
  }
}

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Drawer(
          child: Container(
        color: Color.fromARGB(255, 35, 155, 88),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ignore: prefer_const_constructors
            Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: const IconButton(
                  onPressed: null,
                  icon: Icon(Icons.menu,
                      color: Color.fromARGB(255, 255, 255, 255))),
            ),
            Container(
              padding: const EdgeInsets.only(top: 20.0, left: 15),
              child: Row(
                children: [
                  Container(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: SizedBox(
                        child: Image.asset(
                          'assets/profilepic.png',
                        ),
                        width: 70,
                        height: 70,
                      ),
                    ),
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white,
                          blurRadius: 0,
                          spreadRadius: 1,
                          offset: const Offset(0, 0),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Julious Babaw',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            )),
                        Text('Active',
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Colors.white,
                            ))
                      ],
                    ),
                  )
                ],
              ),
            ),
            Divider(
              height: 40,
              thickness: 1,
              indent: 20,
              endIndent: 20,
              color: Color.fromARGB(255, 192, 190, 190),
            ),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0, left: 5),
                child: Wrap(
                  runSpacing: 16,
                  children: <Widget>[
                    ListTile(
                        leading: const Icon(Icons.account_circle_outlined,
                            color: Color.fromARGB(255, 255, 255, 255)),
                        title: const Text('Profile',
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Colors.white,
                            )),
                        onTap: () async {
                          await logout();
                          // ignore: use_build_context_synchronously
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(builder: (context) => Login()),
                              (route) => false);
                        }),
                    ListTile(
                        leading: const Icon(Icons.menu_book,
                            color: Color.fromARGB(255, 255, 255, 255)),
                        title: const Text('History',
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Colors.white,
                            )),
                        onTap: () async {
                          await logout();
                          // ignore: use_build_context_synchronously
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(builder: (context) => Login()),
                              (route) => false);
                        }),
                    ListTile(
                        leading: const Icon(Icons.logout,
                            color: Color.fromARGB(255, 255, 255, 255)),
                        title: const Text('Log-out',
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Colors.white,
                            )),
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
            ),
          ],
        ),
      ));
}
