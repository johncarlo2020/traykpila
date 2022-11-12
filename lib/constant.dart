// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

const baseUrl = 'http://192.168.100.84/traykpila-api/public/api';
// const baseUrl = 'http://192.168.1.13/traykpila-api/public/api';
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
              child: Container(
                margin: const EdgeInsets.all(10.0),
                width: 90.0,
                height: 90.0,
                // ignore: unnecessary_new
                decoration: new BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: const Color.fromRGBO(77, 206, 135, 1.0),
                  border: Border.all(
                      color: const Color.fromARGB(255, 255, 255, 255)),
                  // ignore: prefer_const_literals_to_create_immutables
                  boxShadow: [
                    // BoxShadow(color: Colors.green, spreadRadius: 3),
                  ],
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: Image.asset('assets/pasenger.png'),
                      style: TextButton.styleFrom(
                        backgroundColor:
                            const Color.fromRGBO(77, 206, 135, 1.0),
                      ),
                      onPressed: () {},
                    ),
                    const Spacer(),
                    Column(
                      children: [Text('Terminal'), Text(Terminal)],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(10.0),
                width: 90.0,
                height: 90.0,
                // ignore: unnecessary_new
                decoration: new BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: const Color.fromRGBO(77, 206, 135, 1.0),
                  border: Border.all(
                      color: const Color.fromARGB(255, 255, 255, 255)),
                  // ignore: prefer_const_literals_to_create_immutables
                  boxShadow: [
                    // BoxShadow(color: Colors.green, spreadRadius: 3),
                  ],
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: Image.asset('assets/pasenger.png'),
                      style: TextButton.styleFrom(
                        backgroundColor:
                            const Color.fromRGBO(77, 206, 135, 1.0),
                      ),
                      onPressed: () {},
                    ),
                    const Spacer(),
                    Column(
                      children: [Text('User'), Text(User)],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(10.0),
            width: 90.0,
            height: 90.0,
            // ignore: unnecessary_new
            decoration: new BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: const Color.fromRGBO(77, 206, 135, 1.0),
              border:
                  Border.all(color: const Color.fromARGB(255, 255, 255, 255)),
              // ignore: prefer_const_literals_to_create_immutables
              boxShadow: [
                // BoxShadow(color: Colors.green, spreadRadius: 3),
              ],
            ),
            child: Row(
              children: [
                IconButton(
                  icon: Image.asset('assets/pasenger.png'),
                  style: TextButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(77, 206, 135, 1.0),
                  ),
                  onPressed: () {},
                ),
                const Spacer(),
                Column(
                  children: [Text('Driver'), Text(Driver)],
                ),
              ],
            ),
          ),
        )
      ],
    ),
  );
}
