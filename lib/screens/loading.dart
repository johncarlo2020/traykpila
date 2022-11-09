
import 'package:flutter/material.dart';
import 'package:traykpila/constant.dart';
import 'package:traykpila/models/api.response.dart';
import 'package:traykpila/screens/welcome.dart';
import 'package:traykpila/services/user_service.dart';
import 'package:traykpila/screens/login.dart';

import 'package:traykpila/screens/admin/home.dart' as adminHome;
import 'package:traykpila/screens/driver/home.dart' as driverHome;
import 'package:traykpila/screens/home.dart' as passengerHome;



class Loading extends StatefulWidget {
  const Loading({super.key});

    @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {

  void _loadUserInfo() async{
    String token = await getToken();
    String role = await getRoleLogin();

    if(token == ''){
      // ignore: prefer_const_constructors, use_build_context_synchronously
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Welcome()), (route) => false);
    }else{
      ApiResponse response = await getUserDetail();

      if(response.error == null){
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
      }else if(response.error == unauthorized){
        // ignore: prefer_const_constructors, use_build_context_synchronously
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Welcome()), (route) => false);
      }else{
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:Text('${response.error}')
        ));
      }
    }
  }

  @override
  void initState(){
    _loadUserInfo();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      color: Colors.white,
      child: const Center(
        child: CircularProgressIndicator()
        ),
    );
  }
}