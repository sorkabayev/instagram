import 'package:flutter/material.dart';
MaterialButton setButton({required String title, required void Function()? onPressed,Icon? icon}){
 return MaterialButton(
    onPressed: onPressed,
    child: Text(title, style: const TextStyle(fontSize: 16, color: Colors.black,fontWeight: FontWeight.bold),
  ));
}