import 'package:flutter/material.dart';

ClipRRect textField({required String hintText,bool? isHidden , required TextEditingController textEditingController }){
  return ClipRRect(
    borderRadius: BorderRadius.circular(7.5),
    child: TextField(
      style: const TextStyle(
        color:Colors.white,fontSize: 16
      ),
      controller: textEditingController,
      obscureText: isHidden ?? false,
      decoration: InputDecoration(
        border: InputBorder.none,
        filled: true,
        fillColor: Colors.white.withOpacity(0.2),
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.white54)
      ),
    ),
  );
}