// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

 const baseUrl = 'http://192.168.100.84/traykpila-api/public/api';
// const baseUrl = 'http://192.168.1.13/traykpila-api/public/api';
const loginUrl = baseUrl + '/login';
const registerUrl = baseUrl + '/register';
const registerUrlNew = baseUrl + '/register_new';

const logoutUrl = baseUrl + '/logout';
const userUrl = baseUrl + '/user';

//tricycle api
const terminalCount = baseUrl + '/terminal/count';
const userCount = baseUrl + '/user/count';
const driverCount = baseUrl + '/driver/count';
const terminalCreate = baseUrl + '/terminal/create';
const terminalShow = baseUrl + '/terminal';

//tricycle api
const tricycleCreate = baseUrl + '/tricyle/create';
const tricycleShow = baseUrl + '/tricycle';

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
                      width: 70,
                      height: 70,
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
