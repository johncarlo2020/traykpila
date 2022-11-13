import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:traykpila/models/terminal.dart';

import '../../constant.dart';
import '../../services/user_service.dart';
import '../login.dart';

import 'dart:io';
import 'package:image_picker/image_picker.dart';

import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Home> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController txtName = TextEditingController();
  TextEditingController txtAdress = TextEditingController();

  final Completer<GoogleMapController> _controller = Completer();
  late String terminalCount = '';
  late String userCount = '';
  late String driverCount = '';
  late File _image;
  final picker = ImagePicker();
  var sreenName = 'Dashboard';

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

  Future getImage() async {
    print('adasdas');
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        print(_image.path);
      } else {
        print('No image selected.');
      }
    });
  }

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

  void _getLocation() async {
    String _host = 'https://maps.google.com/maps/api/geocode/json';
    String _key = 'AIzaSyDkvOCup04GujFtnVfUFxynfKATbXx0HFg';

    print(loading);
    Location location = Location();

    location.getLocation().then(
      (location) async {
        currentLocation = location;
        String lat = currentLocation!.latitude!.toString();
        String lng = currentLocation!.longitude!.toString();

        final url = '$_host?key=$_key&language=en&latlng=$lat,$lng';
        if (lat != null && lng != null) {
          var response = await http.get(Uri.parse(url));
          if (response.statusCode == 200) {
            Map data = jsonDecode(response.body);
            String _formattedAddress = data["results"][0]["formatted_address"];
            print("response ==== $_formattedAddress");
            txtAdress.text = _formattedAddress;
            print(_formattedAddress);
          } else
            print(null);
        } else
          print(null);
        setState(() {
          loading = false;
        });
      },
    );
  }

  void _register() {
    Map<String, String> body = {
      'name': txtName.text,
      'address': txtAdress.text,
      'image': _image.path,
      'lat': currentLocation!.latitude!.toString(),
      'lng': currentLocation!.longitude!.toString(),
    };
    Future<bool> add = addImage(body, _image.path);
    print(add);
  }

  @override
  void initState() {
    _Count();
    super.initState();
  }

  // ignore: non_constant_identifier_names
  Widget AddTerminal() => (Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Form(
          key: formkey,
          child: ListView(
            padding: const EdgeInsets.all(32),
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 50.0),
                child: Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    buildProfileImage(),
                    Positioned(
                        bottom: 0,
                        right: 100,
                        width: 50,
                        child: IconButton(
                          icon: const Icon(
                            Icons.add_a_photo,
                            size: 50,
                            color: Color.fromARGB(255, 11, 172, 78),
                          ),
                          onPressed: () {
                            getImage();
                          },
                        ))
                  ],
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                validator: (val) => val!.isEmpty ? 'Invalid Name' : null,
                controller: txtName,

                // ignore: prefer_const_constructors
                decoration: InputDecoration(
                    isDense: true,
                    labelText: 'Terminal Name',
                    border: InputBorder.none,
                    filled: true,
                    fillColor: const Color.fromRGBO(229, 255, 238, 1.0),
                    prefixIcon: const Icon(
                      Icons.account_circle_sharp,
                      size: 30,
                    )),
              ),
              const SizedBox(height: 10),
              TextFormField(
                validator: (val) => val!.isEmpty ? 'Invalid Address' : null,
                controller: txtAdress,

                // ignore: prefer_const_constructors
                decoration: InputDecoration(
                    isDense: true,
                    labelText: 'Address',
                    border: InputBorder.none,
                    filled: true,
                    fillColor: const Color.fromRGBO(229, 255, 238, 1.0),
                    prefixIcon: const Icon(
                      Icons.add_location_alt_outlined,
                      size: 30,
                    )),
              ),
              const SizedBox(height: 10),
              const Text(
                'Or',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              loading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : TextButton(
                      onPressed: () {
                        setState(() {
                          loading = true;
                          _getLocation();
                        });
                      },
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                        const Color.fromARGB(255, 11, 172, 78),
                      )),
                      // ignore: prefer_const_constructors
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: const Text("GPS",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.normal,
                              color: Color.fromARGB(255, 255, 255, 255),
                            )),
                      )),
              Padding(
                  padding: const EdgeInsets.only(top: 70.0),
                  child: TextButton(
                      onPressed: () {
                        if (formkey.currentState!.validate()) {
                          formkey.currentState!.save();
                          _register();
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      super.widget));
                        }
                      },
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                        const Color.fromARGB(255, 11, 172, 78),
                      )),
                      // ignore: prefer_const_constructors
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: const Text("Register",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.normal,
                              color: Color.fromARGB(255, 255, 255, 255),
                            )),
                      )))
            ],
          ),
        ),
      ));

  Widget buildProfileImage() => Container(
        // backgroundColor: Color.fromARGB(255, 3, 139, 60),
        // radius: 80,
        width: 116,
        height: 93,
        // ignore: unnecessary_new
        decoration: new BoxDecoration(
          color: const Color.fromRGBO(243, 240, 240, 1.0),
          border: Border.all(color: Color.fromARGB(171, 8, 223, 133), width: 5),
        ),
        child: const Image(
          image: AssetImage('assets/profile.png'),
          width: 40,
          height: 40,
        ),
      );

  // ignore: non_constant_identifier_names
  Widget TerminalList() => Padding(
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
                                  trailing: Text('view'),
                                ),
                              );
                            });
                      }
                    }),
              )
            ],
          )),
        ),
      );
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers

    List<Widget> _pages = <Widget>[
      Dashboard(terminalCount, userCount, driverCount),
      AddTerminal(),
      TerminalList(),
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
