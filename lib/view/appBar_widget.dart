import 'package:flutter/material.dart';

import '../services/theme_service.dart';

AppBar appBar({required String title, Icon? icon, Icon? icon2, void Function()? onPressed}){
  return AppBar(
    title: Text(title,style: ThemeService.appBarStyle,),
    centerTitle: true,
    actions: [
      if(icon != null)IconButton(onPressed: onPressed, icon: icon),
      if(icon2 != null)IconButton(onPressed: onPressed, icon: icon2)
    ],
  );
}