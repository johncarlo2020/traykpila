import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:traykpila/constant.dart';
import 'package:traykpila/main.dart';
import 'package:traykpila/screens/register.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();


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
                keyboardType: TextInputType.emailAddress,
                controller: txtEmail,
                validator: (val) => val!.isEmpty ? 'Invalid email address' : null,
                decoration: kInputDecoration('Email'),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: txtPassword,
                obscureText: true,
                validator: (val) => val!.isEmpty ? 'Invalid password' : null,
                decoration: kInputDecoration('Password'),
              ),
              SizedBox(height: 10),
              TextButton(
                child: Text('Login' , style: TextStyle(color: Colors.white),),
                style: ButtonStyle(
                  backgroundColor: MaterialStateColor.resolveWith((states) => Colors.blue),
                  padding: MaterialStateProperty.resolveWith((states) => EdgeInsets.symmetric(vertical: 10)),
                  ),
                onPressed: () {
                  if(formkey.currentState!.validate()){

                  }
                },
                ),
              SizedBox(height: 10),
              kLoinRegisterhint('Dont have an account? ', 'Register', (){
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Register()), (route) => false);
              })

            ],
            
          ),
        ),
         
    );
  }
}