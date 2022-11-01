import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:traykpila/screens/login.dart';

import '../constant.dart';

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



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        // ignore: prefer_const_constructors
        title:Text('Traykpila'),
        centerTitle:true,
      ),

      body: Form(
        key: formkey,
        child: ListView(
          padding: EdgeInsets.all(32),
            children: [
              TextFormField(
                controller: txtName,
                validator: (val) => val!.isEmpty ? 'Invalid Name' : null,
                decoration: kInputDecoration('Name'),
              ),
              SizedBox(height: 10),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                controller: txtEmail,
                validator: (val) => val!.isEmpty ? 'Invalid email address' : null,
                decoration: kInputDecoration('Email'),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: txtPassword,
                validator: (val) => val!.isEmpty ? 'Invalid Password' : null,
                obscureText: true,
                decoration: kInputDecoration('Password'),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: txtPassword2,
                validator: (val) => val!.isEmpty ? 'Invalid Password' : null,
                obscureText: true,
                decoration: kInputDecoration('Repeat Password'),
              ),
              SizedBox(height: 10),
               kLoinRegisterhint('Already have an Account? ', 'Login', (){
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Login()), (route) => false);
              })
            ]
        )

      )
    );
  }
}