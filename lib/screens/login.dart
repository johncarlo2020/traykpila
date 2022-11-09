import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'
    show SharedPreferences;
import 'package:traykpila/constant.dart';
import 'package:traykpila/models/api.response.dart';
import 'package:traykpila/screens/register.dart';
import 'package:traykpila/services/user_service.dart';

import '../models/user.dart';
// ignore: library_prefixes
import 'home.dart' as passengerHome;
// ignore: library_prefixes
import 'driver/home.dart' as driverHome;
import 'admin/home.dart' as adminHome;


class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  bool loading = false;

  void _loginUser() async {
    ApiResponse response = await login(txtEmail.text, txtPassword.text);
    if (response.error == null) {
      _saveAndRedirectToHome(response.data as User);
    } else {
      setState(() {
        loading = false;
      });
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }

  void _getRole() async{
    String? role = await getRole();
  }

  @override
  void initState() {
    _getRole();
    super.initState();
  }

  void _saveAndRedirectToHome(User user) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('token', user.token ?? '');
    await pref.setInt('userId', user.id ?? 0);
    await pref.setString('role', user.role ?? '0');
    
    String role = await getRoleLogin();
    print(role);

    if (role == '1') {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => driverHome.Home()),
          (route) => false);
    } else if (role == '2') {
      
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => adminHome.Home()),
          (route) => false);
    }
     else {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => passengerHome.Home()),
          (route) => false);
    }

    // ignore: prefer_const_constructors, use_build_context_synchronously
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 70.0),
        child: Form(
          key: formkey,
          child: ListView(
            padding: const EdgeInsets.all(32),
            children: [
              const Image(
                image: AssetImage('assets/logoforwhite.png'),
                width: 150,
                height: 150,
              ),
              const Text(
                'Welcome to TricPila',
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
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                controller: txtEmail,
                validator: (val) =>
                    val!.isEmpty ? 'Invalid email address' : null,
                decoration: const InputDecoration(
                    isDense: true,
                    labelText: 'Email',
                    border: InputBorder.none,
                    filled: true,
                    fillColor: Color.fromRGBO(229, 255, 238, 1.0),
                    prefixIcon: Icon(
                      Icons.email_outlined,
                      size: 30,
                    )),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: txtPassword,
                obscureText: true,
                validator: (val) =>
                    val!.length < 6 ? 'Required at least 6 characters' : null,
                decoration: const InputDecoration(
                    isDense: true,
                    labelText: 'Password',
                    border: InputBorder.none,
                    filled: true,
                    fillColor: Color.fromRGBO(229, 255, 238, 1.0),
                    prefixIcon: Icon(
                      Icons.key,
                      size: 30,
                    )),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: () {
                        if (formkey.currentState!.validate()) {
                          setState(() {
                            loading = true;
                          });
                        }
                      },
                      // ignore: prefer_const_constructors
                      child: Padding(
                        padding: const EdgeInsets.only(top: 0.0),
                        child: const Text("Forgot Password",
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 5, 110, 31),
                            )),
                      )),
                ],
              ),
              loading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(top: 40.0),
                      child: TextButton(
                          onPressed: () {
                            if (formkey.currentState!.validate()) {
                              setState(() {
                                loading = true;
                                _loginUser();
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
                            child: const Text("Login",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.normal,
                                  color: Color.fromARGB(255, 255, 255, 255),
                                )),
                          )),
                    ),
              const SizedBox(height: 10),
              kLoinRegisterhint('Dont have an account? ', 'Register', () async {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => Register()),
                    (route) => false);
              })
            ],
          ),
        ),
      ),
    );
  }
}
