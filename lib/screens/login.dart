import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:traykpila/constant.dart';
import 'package:traykpila/main.dart';
import 'package:traykpila/models/api.response.dart';
import 'package:traykpila/screens/register.dart';
import 'package:traykpila/services/user_service.dart';

import '../models/user.dart';
import 'home.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  bool loading=false;

  void _loginUser() async {
    ApiResponse response = await login(txtEmail.text, txtPassword.text);
    if(response.error == null){
      _saveAndRedirectToHome(response.data as User);
    }else{
      setState(() {
        loading=false;
      });
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${response.error}')
      ));
    }

  }

  void  _saveAndRedirectToHome(User user) async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('token', user.token ?? '');
    await pref.setInt('userId', user.id ?? 0);
        // ignore: prefer_const_constructors, use_build_context_synchronously
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Home()), (route) => false);

  }

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
                validator: (val) => val!.length < 6 ? 'Required at least 6 characters' : null,
                decoration: kInputDecoration('Password'),
              ),
              SizedBox(height: 10),
              loading? Center(child: CircularProgressIndicator(),)
              :
              kTextButton('Login', (){
                    if(formkey.currentState!.validate()){
                      setState(() {
                        loading = true;
                        _loginUser();
                      });
                    }
                  
              }),
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