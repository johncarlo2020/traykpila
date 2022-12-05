import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// ignore: library_prefixes
import 'package:traykpila/screens/register.dart' as registerPassenger;

import '../constant.dart';
import 'login.dart';

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
        // ignore: prefer_const_constructors
        decoration:
            const BoxDecoration(color: Color.fromRGBO(37, 195, 108, 1.0)),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.only(top: 110.0),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              alignment: Alignment.center,
              child: Column(
                children: <Widget>[
                  const Image(
                    height: 140,
                    width: 140,
                    image: AssetImage('assets/trayklogo.png'),
                  ),
                  const Text(
                    'Welcome to TricPila',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(247, 242, 100, 1.0)),
                  ),
                  const Text(
                    'Your nunber one tricycle booking App in the Philippines',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.normal,
                        color: Color.fromARGB(255, 255, 255, 255)),
                  ),
                  const Divider(
                    height: 20,
                    thickness: 2,
                    indent: 30,
                    endIndent: 30,
                    color: Color.fromRGBO(247, 242, 100, 1.0),
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    'Register as',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(247, 242, 100, 1.0)),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 20.0, // gap between adjacent chips
                    runSpacing: 4.0, // gap between lines
                    children: <Widget>[
                      Column(
                        children: [
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(120, 120),
                                backgroundColor:
                                    const Color.fromARGB(255, 72, 206, 133),
                              ),
                              onPressed: () async {
                                SharedPreferences pref =
                                    await SharedPreferences.getInstance();
                                await pref.setString('userRole', '1');
                                // ignore: use_build_context_synchronously
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const registerPassenger
                                                .Register()));
                              },
                              child: const Image(
                                image: AssetImage('assets/driver.png'),
                                width: 80,
                                height: 80,
                              )),
                          const SizedBox(height: 8),
                          const Text('Driver',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.normal,
                                color: Color.fromARGB(255, 255, 255, 255),
                              ))
                        ],
                      ),
                      Column(
                        children: [
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(120, 120),
                                backgroundColor:
                                    const Color.fromARGB(255, 72, 206, 133),
                              ),
                              onPressed: () async {
                                SharedPreferences pref =
                                    await SharedPreferences.getInstance();
                                await pref.setString('userRole', '0');
                                // ignore: use_build_context_synchronously
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const registerPassenger
                                                .Register()));
                              },
                              child: const Image(
                                image: AssetImage('assets/pasenger.png'),
                                width: 80,
                                height: 80,
                              )),
                          const SizedBox(height: 8),
                          const Text('Passenger',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.normal,
                                color: Color.fromARGB(255, 255, 255, 255),
                              ))
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 150),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Already have an Account? ',
                          style: TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255))),
                      GestureDetector(
                        child: const Text('Login',
                            style: TextStyle(
                                color: Color.fromRGBO(247, 242, 100, 1.0))),
                        onTap: () {
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => const Login()),
                              (route) => false);
                        },
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    ));
  }
}
