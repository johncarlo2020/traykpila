import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

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
            height: MediaQuery.of(context).size.width * 0.65,
            width: MediaQuery.of(context).size.width * 0.85,
            child: Column(
              children: const <Widget>[
                Expanded(
                  child: FittedBox(
                    child: Image(
                      image: AssetImage('assets/trayklogo.png'),
                    ),
                  ),
                ),
                Text('Welcome to TricPila'),
                Text('Your nunber one tricycle booking App in the Philippines'),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
