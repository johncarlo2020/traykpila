import 'package:flutter/material.dart';

const baseUrl = 'http://192.168.1.19/traykpila-api/public/api';
const loginUrl = baseUrl + '/login';
const registerUrl = baseUrl + '/register';
const logoutUrl = baseUrl + '/logout';
const userUrl = baseUrl + '/user';

const serverError = 'Server error';
const unauthorized = 'Unauthorized';
const somethingWentWrong = 'Something went wrong, try again';


InputDecoration kInputDecoration(String label){
  return InputDecoration(
                  labelText: label,
                  contentPadding:EdgeInsets.all(10),
                  border: OutlineInputBorder(borderSide: BorderSide(width: 1,color: Colors.black))
                  );
}

TextButton kTextButton (String label, Function onPressed){
  return TextButton(
                child: Text(label , style: TextStyle(color: Colors.white),),
                style: ButtonStyle(
                  backgroundColor: MaterialStateColor.resolveWith((states) => Colors.blue),
                  padding: MaterialStateProperty.resolveWith((states) => EdgeInsets.symmetric(vertical: 10)),
                  ),
                onPressed: () => onPressed(),
                );
}

Row kLoinRegisterhint(String text, String label, Function onTap){
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(text),
      GestureDetector(
        child: Text(label, style:TextStyle(color:Colors.blue)),
        onTap: ()=>onTap(),
      )
    ],
    );
}

