import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:traykpila/screens/login.dart';
import 'package:traykpila/services/user_service.dart';

import '../constant.dart';
import '../models/api.response.dart';
import '../models/user.dart';
import 'home.dart' as passengerHome;
// ignore: library_prefixes
import 'driver/home.dart' as driverHome;
import 'admin/home.dart' as adminHome;

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtName = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  TextEditingController txtPassword2 = TextEditingController();
  TextEditingController txtAdress = TextEditingController();
  bool loading = false;

  Future pickImage() async {
    await ImagePicker().pickImage(source: ImageSource.gallery);
  }

  void _registerUser() async {
    String role = await getRole();
    print(role);
    ApiResponse response = await register(
        txtName.text, txtEmail.text, txtPassword.text, role, txtAdress.text);

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

  void _saveAndRedirectToHome(User user) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('token', user.token ?? '');
    await pref.setInt('userId', user.id ?? 0);
    await pref.setString('role', user.role ?? '0');
    String role = await getRoleLogin();
    // ignore: prefer_const_constructors, use_build_context_synchronously
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
    } else {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => passengerHome.Home()),
          (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.only(top: 70.0),
      child: Form(
          key: formkey,
          child: ListView(padding: const EdgeInsets.all(32), children: [
            // ignore: prefer_const_constructors
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: const Text(
                'Register',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 25, 154, 90),
                ),
              ),
            ),
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
              controller: txtName,
              validator: (val) => val!.isEmpty ? 'Invalid Name' : null,
              // ignore: prefer_const_constructors
              decoration: InputDecoration(
                  isDense: true,
                  labelText: 'Full name',
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
              controller: txtAdress,
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
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              controller: txtEmail,
              validator: (val) => val!.isEmpty ? 'Invalid email address' : null,
              // ignore: prefer_const_constructors
              decoration: InputDecoration(
                  isDense: true,
                  labelText: 'Email',
                  border: InputBorder.none,
                  filled: true,
                  fillColor: const Color.fromRGBO(229, 255, 238, 1.0),
                  prefixIcon: const Icon(
                    Icons.email_outlined,
                    size: 30,
                  )),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: txtPassword,
              validator: (val) => val!.isEmpty ? 'Invalid Password' : null,
              obscureText: true,
              // ignore: prefer_const_constructors
              decoration: InputDecoration(
                  isDense: true,
                  labelText: 'Password',
                  border: InputBorder.none,
                  filled: true,
                  fillColor: const Color.fromRGBO(229, 255, 238, 1.0),
                  prefixIcon: const Icon(
                    Icons.key,
                    size: 30,
                  )),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: txtPassword2,
              validator: (val) =>
                  val != txtPassword.text ? 'Password not match' : null,
              obscureText: true,
              // ignore: prefer_const_constructors
              decoration: InputDecoration(
                  isDense: true,
                  labelText: 'Repeat password',
                  border: InputBorder.none,
                  filled: true,
                  fillColor: const Color.fromRGBO(229, 255, 238, 1.0),
                  prefixIcon: const Icon(
                    Icons.key,
                    size: 30,
                  )),
            ),

            Padding(
                padding: const EdgeInsets.only(top: 70.0),
                child: TextButton(
                    onPressed: () {
                      if (formkey.currentState!.validate()) {
                        setState(() {
                          loading = true;
                          _registerUser();
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
            const SizedBox(height: 10),
            kLoinRegisterhint('Already have an Account? ', 'Login', () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const Login()),
                  (route) => false);
            })
          ])),
    ));
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
}
