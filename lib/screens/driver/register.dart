import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:traykpila/screens/login.dart';
import 'package:traykpila/services/user_service.dart';

import '../../constant.dart';
import '../../models/api.response.dart';
import '../../models/user.dart';
import 'home.dart' as passengerHome;

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController txtName = TextEditingController();
  TextEditingController txtBodyNum = TextEditingController();
  TextEditingController txtPlateNum= TextEditingController();
  TextEditingController txtMaxPassenger = TextEditingController();
  bool loading = false;

  late File _image;
  final picker = ImagePicker();

  

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        print(_image.path);
      } else {
        print('No image selected.');
      }
    });
  }
    Future<void> _register() async {
      int response = await getUserId();
      Map<String, String> body = {
        'name': txtName.text,
        'body_number': txtBodyNum.text,
        'image': _image.path,
        'plate_number': txtPlateNum.text,
        'max_passenger': txtMaxPassenger.text,
        'user_id':response.toString()
      };
      if (await addTricycle(body, _image.path) == false) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Server Error')));
   } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Added Successfully')));
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) => super.widget));
      }
  }

 
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Register'),
          //<Widget>[]
          backgroundColor: const Color.fromARGB(255, 72, 206, 133),
        ),
        body: Form(
            key: formkey,
            child: ListView(padding: const EdgeInsets.all(32), children: [
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
                controller: txtName,
                validator: (val) => val!.isEmpty ? 'Invalid Name' : null,
                // ignore: prefer_const_constructors
                decoration: InputDecoration(
                    isDense: true,
                    labelText: 'Full name',
                    border: const OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 1, color: Colors.greenAccent), //<-- SEE HERE
                    ),
                    filled: true,
                    fillColor: const Color.fromRGBO(229, 255, 238, 1.0),
                    prefixIcon: const Icon(
                      Icons.account_circle_sharp,
                      size: 30,
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 1, color: Colors.greenAccent), //<-- SEE HERE
                    )),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: txtBodyNum,
                validator: (val) => val!.isEmpty ? 'Invalid Address' : null,
                // ignore: prefer_const_constructors
                decoration: InputDecoration(
                    isDense: true,
                    labelText: 'Body Number',
                    border: const OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 1, color: Colors.greenAccent), //<-- SEE HERE
                    ),
                    filled: true,
                    fillColor: const Color.fromRGBO(229, 255, 238, 1.0),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 1, color: Colors.greenAccent), //<-- SEE HERE
                    ),
                    prefixIcon: const Icon(
                      Icons.add_location_alt_outlined,
                      size: 30,
                    )),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: txtPlateNum,
                validator: (val) =>
                    val!.isEmpty ? 'Invalid plate number' : null,
                // ignore: prefer_const_constructors
                decoration: InputDecoration(
                    isDense: true,
                    labelText: 'Plate Number',
                    border: const OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 1, color: Colors.greenAccent), //<-- SEE HERE
                    ),
                    filled: true,
                    fillColor: const Color.fromRGBO(229, 255, 238, 1.0),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 1, color: Colors.greenAccent), //<-- SEE HERE
                    ),
                    prefixIcon: const Icon(
                      Icons.email_outlined,
                      size: 30,
                    )),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: txtMaxPassenger,
                validator: (val) => val!.isEmpty ? 'max passenger' : null,
                obscureText: true,
                // ignore: prefer_const_constructors
                decoration: InputDecoration(
                    isDense: true,
                    labelText: 'Max Passenger',
                    border: const OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 1, color: Colors.greenAccent), //<-- SEE HERE
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 1, color: Colors.greenAccent), //<-- SEE HERE
                    ),
                    filled: true,
                    fillColor: const Color.fromRGBO(229, 255, 238, 1.0),
                    prefixIcon: const Icon(
                      Icons.key,
                      size: 30,
                    )),
              ),
              const SizedBox(height: 10),
              Padding(
                  padding: const EdgeInsets.only(top: 70.0),
                  child: TextButton(
                      onPressed: () {
                        if (formkey.currentState!.validate()) {
                          setState(() {
                            loading = true;
                            _register();
                          });
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
                      ))),
              const SizedBox(height: 20),
            ])));
  }

  Widget buildProfileImage() => Container(
        width: 116,
        height: 93,
        // ignore: unnecessary_new
        decoration: new BoxDecoration(
          color: const Color.fromRGBO(243, 240, 240, 1.0),
          border: Border.all(
              color: const Color.fromARGB(171, 8, 223, 133), width: 5),
        ),
        child: const Image(
          image: AssetImage('assets/profile.png'),
          width: 40,
          height: 40,
        ),
      );
}
