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
  TextEditingController txtPlateNum = TextEditingController();
  TextEditingController txtMaxPassenger = TextEditingController();
  bool loading = false;
  int imageClick = 0;


  late File _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        imageClick = 1;
        print(_image.path);
      } else {
        print('No image selected.');
      }
    });
  }

   void clearAll() {
    imageClick = 0;
    txtBodyNum.text = '';
    txtPlateNum.text = '';
    txtMaxPassenger.text = '';
    txtName.text = '';
    loading = false;
  }

  void _register() async {
    int response = await getUserId();
    Map<String, String> body = {
      'name': txtName.text,
      'body_number': txtBodyNum.text,
      'image': _image.path,
      'plate_number': txtPlateNum.text,
      'max_passenger': txtMaxPassenger.text,
      'user_id': response.toString()
    };
      String? image = _image ==  null ? null : getStringImage(_image);

    ApiResponse response1 = await addTricycle(txtName.text,txtPlateNum.text,txtBodyNum.text,txtMaxPassenger.text,response.toString(), image);

    if(response1.error ==  null) {
      setState(() {
          loading = false;
          clearAll();
        });
      ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Added Successfully')));

        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) => super.widget));

    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${response1.error}')
      ));
    }
  }

  @override
  void initState() {
    imageClick = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Register Tricycle'),
          //<Widget>[]
          backgroundColor: const Color.fromARGB(255, 72, 206, 133),
        ),
        drawer: NavigationDrawer(),
        body: Form(
            key: formkey,
            child: ListView(children: [
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                height: 180,
                alignment: Alignment.center,
                child: buildProfileImage(),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 20),
                ),
                onPressed: () {
                  getImage();
                },
                child: const Text('Add Photo',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                        color: Color.fromARGB(255, 6, 122, 0))),
              ),
              Container(
                padding: const EdgeInsets.only(top: 0, right: 30.0, left: 30.0),
                child: Column(
                  children: [
                    TextFormField(
                      controller: txtName,
                      validator: (val) => val!.isEmpty ? 'Invalid Name' : null,
                      // ignore: prefer_const_constructors
                      decoration: InputDecoration(
                        isDense: true,
                        labelText: 'Full name',
                        filled: false,
                        prefixIcon: const Icon(
                          Icons.account_circle_sharp,
                          color: Color.fromRGBO(49, 200, 116, 1.0),
                          size: 25,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: txtBodyNum,
                      validator: (val) =>
                          val!.isEmpty ? 'Invalid Address' : null,
                      // ignore: prefer_const_constructors
                      decoration: InputDecoration(
                          isDense: true,
                          labelText: 'Body Number',
                          filled: false,
                          prefixIcon: const Icon(
                            Icons.account_circle_sharp,
                            color: Color.fromRGBO(49, 200, 116, 1.0),
                            size: 25,
                          )),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: txtPlateNum,
                      validator: (val) =>
                          val!.isEmpty ? 'Invalid plate number' : null,
                      // ignore: prefer_const_constructors
                      decoration: InputDecoration(
                          isDense: true,
                          labelText: 'Plate number',
                          filled: false,
                          prefixIcon: const Icon(
                            Icons.account_circle_sharp,
                            color: Color.fromRGBO(49, 200, 116, 1.0),
                            size: 25,
                          )),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: txtMaxPassenger,
                      validator: (val) => val!.isEmpty ? 'max passenger' : null,
                      // ignore: prefer_const_constructors
                      decoration: InputDecoration(
                          isDense: true,
                          labelText: 'Max passenger',
                          filled: false,
                          prefixIcon: const Icon(
                            Icons.account_circle_sharp,
                            color: Color.fromRGBO(49, 200, 116, 1.0),
                            size: 25,
                          )),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Container(
                  width: double.infinity,
                  height: 60,
                  padding: const EdgeInsets.only(top: 5.0, left: 30, right: 30),
                  child: ElevatedButton(
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
                          ),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ))),
                      // ignore: prefer_const_constructors
                      child: const Text("Register",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.normal,
                            color: Color.fromARGB(255, 255, 255, 255),
                          )))),
            ])));
  }

  Widget buildProfileImage() => Container(
        width: 180,
        height: 180,
        decoration: BoxDecoration(
            color: Color.fromRGBO(217, 217, 217, 1.0),
            border: Border.all(
              color: Color.fromRGBO(217, 217, 217, 1.0),
            ),
            borderRadius: BorderRadius.all(Radius.circular(100))),
        child:imageClick == 0
        ?const Image(
          image: AssetImage('assets/tricycle.png'),
          width: 50,
          height: 50,
        ): Image.file(
                _image,
                fit: BoxFit.cover,
              ),
      );
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
                  leading: const Icon(Icons.home),
                  title: const Text('Home'),
                  onTap: () async {
                    await logout();
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => passengerHome.Home()),
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
