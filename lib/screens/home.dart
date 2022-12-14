import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

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
          "Passenger ",
          style: TextStyle(color: Colors.black, fontSize: 16),
        )),
         floatingActionButton: FloatingActionButton(
        onPressed: () {
          signOut();
        },
        child: Icon(Icons.logout_rounded),
        backgroundColor: Colors.green,
      ),
        body: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: (Column(
            children: [
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
                                    color: Color.fromARGB(255, 72, 206, 133),
                                  ),
                                  title: Text(terminal.name.toString()),
                                  subtitle: Text(terminal.address.toString()),
                                  trailing: Text('Book'),
                                  onTap: () {
                                    
                                  },
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
      )
        
        );
  }
}
