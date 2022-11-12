// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// const baseUrl = 'http://192.168.100.84/traykpila-api/public/api';
const baseUrl = 'http://192.168.1.13/traykpila-api/public/api';
const loginUrl = baseUrl + '/login';
const registerUrl = baseUrl + '/register';
const logoutUrl = baseUrl + '/logout';
const userUrl = baseUrl + '/user';

//terminal api
const terminalCount = baseUrl + '/terminal/count';
const userCount = baseUrl + '/user/count';
const driverCount = baseUrl + '/driver/count';

const serverError = 'Server error';
const unauthorized = 'Unauthorized';
const somethingWentWrong = 'Something went wrong, try again';

const String google_api_key = "AIzaSyCHSbhwRN70xEw6oR-HDn8_mcMJtK0xvHI";

Future pickImage() async {
  await ImagePicker().pickImage(source: ImageSource.camera);
}

InputDecoration kInputDecoration(String label) {
  return InputDecoration(
      labelText: label,
      contentPadding: EdgeInsets.all(10),
      border: OutlineInputBorder(
          borderSide: BorderSide(width: 1, color: Colors.black)));
}

TextButton kTextButton(String label, Function onPressed) {
  return TextButton(
    child: Text(
      label,
      style: TextStyle(color: Colors.white),
    ),
    style: ButtonStyle(
      backgroundColor: MaterialStateColor.resolveWith((states) => Colors.blue),
      padding: MaterialStateProperty.resolveWith(
          (states) => EdgeInsets.symmetric(vertical: 10)),
    ),
    onPressed: () => onPressed(),
  );
}

Row kLoinRegisterhint(String text, String label, Function onTap) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(text),
      GestureDetector(
        child: Text(label, style: TextStyle(color: Colors.blue)),
        onTap: () => onTap(),
      )
    ],
  );
}

Row kRow(String text, String text1, String label, Function onTap) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(text),
      Text(text1),
    ],
  );
}

Padding Dashboard(String Terminal, String User, String Driver) {
  return Padding(
    padding: const EdgeInsets.only(top: 20.0),
    child: ListView(
      padding: const EdgeInsets.all(32),
      // ignore: prefer_const_literals_to_create_immutables
      children: [
        const Image(
          image: AssetImage('assets/logoforwhite.png'),
          width: 150,
          height: 150,
        ),
        const Text(
          'Welcome to TraykPila',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 25, 154, 90),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(
            top: 5.0,
            bottom: 30.0,
          ),
          child: Text(
            'Your nunber one tricycle booking App in the Philippines',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: Color.fromARGB(255, 25, 154, 90),
            ),
          ),
        ),
        Row(
          children: <Widget>[
            Expanded(
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(100, 100),
                      backgroundColor: Color.fromARGB(255, 72, 206, 133),
                    ),
                    onPressed: () {},
                    child: Row(
                      children: [
                        Image(
                          image: AssetImage('assets/mapIcon.png'),
                          width: 50,
                          height: 50,
                        ),
                        const Spacer(),
                        Column(
                          children: [
                            Text('User',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 255, 255, 255),
                                )),
                            Text(User,
                                style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 255, 255, 255),
                                ))
                          ],
                        ),
                      ],
                    ))),
            const SizedBox(width: 10),
            Expanded(
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(100, 100),
                      backgroundColor: Color.fromARGB(255, 72, 206, 133),
                    ),
                    onPressed: () {},
                    child: Row(
                      children: [
                        Image(
                          image: AssetImage('assets/personIconSquare.png'),
                          width: 50,
                          height: 50,
                        ),
                        const Spacer(),
                        Column(
                          children: [
                            Text('Terminal',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 255, 255, 255),
                                )),
                            Text(Terminal,
                                style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 255, 255, 255),
                                ))
                          ],
                        ),
                      ],
                    )))
          ],
        ),
        const SizedBox(height: 10),
        Expanded(
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(100, 100),
                  backgroundColor: Color.fromARGB(255, 72, 206, 133),
                ),
                onPressed: () {},
                child: Row(
                  children: [
                    Image(
                      image: AssetImage('assets/car.png'),
                      width: 50,
                      height: 50,
                    ),
                    const Spacer(),
                    Column(
                      children: [
                        Text('Driver',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 255, 255, 255),
                            )),
                        Text(Driver,
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 255, 255, 255),
                            ))
                      ],
                    ),
                  ],
                )))
      ],
    ),
  );
}

Padding AddTerminal() {
  return Padding(
    padding: const EdgeInsets.only(top: 10.0),
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
                      pickImage();
                    },
                  ))
            ],
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          validator: (val) => val!.isEmpty ? 'Invalid Name' : null,
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
        TextButton(
            onPressed: () {},
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
                onPressed: () {},
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
  );
}

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
