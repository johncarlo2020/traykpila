import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:traykpila/screens/login.dart';
import 'package:traykpila/services/user_service.dart';

import '../constant.dart';
import '../models/api.response.dart';
import '../models/user.dart';
import 'home.dart';

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
  bool loading = false;

  void _registerUser() async {
    ApiResponse response = await register(txtName.text, txtEmail.text, txtEmail.text);
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
                validator: (val) => val!=txtPassword.text ? 'Password not match' : null,
                obscureText: true,
                decoration: kInputDecoration('Repeat Password'),
              ),
              kTextButton('Register', (){
                 if(formkey.currentState!.validate()){
                      setState(() {
                        loading = true;
                        _registerUser();
                      });
                    }
                  
              }),
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