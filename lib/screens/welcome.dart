import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:traykpila/screens/login.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

//fuck u gawin mo to

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Container(
        decoration: new BoxDecoration(color: Color.fromRGBO(37, 195, 108, 1.0)),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: Container(
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.width * 0.85,
            width: MediaQuery.of(context).size.width * 0.85,
            child: Column(
              children: <Widget>[
                Row(
                  children: const <Widget>[
                    Expanded(
                      child: Image(
                        height: 70,
                        image: AssetImage('assets/trayklogo.png'),
                      ),
                    )
                  ],
                ),
                Row(
                  children: const <Widget>[
                    Expanded(
                        child: Text(
                      'Welcome to TricPila',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(247, 242, 100, 1.0)),
                    ))
                  ],
                ),
                Row(
                  children: const <Widget>[
                    Expanded(
                        child: Text(
                      'Your nunber one tricycle booking App in the Philippines',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.normal,
                          color: Color.fromARGB(255, 255, 255, 255)),
                    ))
                  ],
                ),
                Wrap(
                  spacing: 8.0, // gap between adjacent chips
                  runSpacing: 4.0, // gap between lines
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(10.0),
                        width: 90.0,
                        height: 90.0,
                        decoration: new BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: Color.fromRGBO(77, 206, 135, 1.0),
                          border: Border.all(
                              color: Color.fromARGB(255, 255, 255, 255)),
                          boxShadow: [
                            // BoxShadow(color: Colors.green, spreadRadius: 3),
                          ],
                        ),
                        child: IconButton(
                          icon: Image.asset('assets/driver.png'),
                          style: TextButton.styleFrom(
                            backgroundColor: Color.fromRGBO(77, 206, 135, 1.0),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Login()));
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(10.0),
                        width: 90.0,
                        height: 90.0,
                        decoration: new BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: Color.fromRGBO(77, 206, 135, 1.0),
                          border: Border.all(
                              color: Color.fromARGB(255, 255, 255, 255)),
                          boxShadow: [
                            // BoxShadow(color: Colors.green, spreadRadius: 3),
                          ],
                        ),
                        child: IconButton(
                          icon: Image.asset('assets/pasenger.png'),
                          style: TextButton.styleFrom(
                            backgroundColor: Color.fromRGBO(77, 206, 135, 1.0),
                          ),
                          onPressed: () {},
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
