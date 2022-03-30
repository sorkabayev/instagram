import 'package:flutter/material.dart';
import 'package:instagram/models/post_model.dart';
import 'package:instagram/pages/add_page.dart';
import 'package:instagram/pages/profile_page.dart';
import 'package:instagram/pages/like_page.dart';
import 'package:instagram/pages/home_page.dart';
import 'package:instagram/pages/search_page.dart';
class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  static const String id = "main_page";

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  int currentIndex = 0;
  int sellectedIndex = 0;

  bool isDark = false;

  PageController controller = PageController();

  @override
  void initState() {
    // TODO: implement initState
    controller.addListener(() {
      setState(() {
       sellectedIndex = controller.page!.toInt();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: controller,
        children:  [
          HomePage(),
          SearchPage(),
          AddPage(),
          LikePage(),
          ProfilePage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: isDark ? Colors.black : Colors.white ,
        elevation: 0,
        showUnselectedLabels: false,
        showSelectedLabels: false,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        selectedIconTheme: IconThemeData(color: Colors.black),
        unselectedIconTheme: IconThemeData(color: Colors.grey),
        selectedLabelStyle: TextStyle(color: Colors.black,fontSize: 13),
        iconSize: 30,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: GestureDetector(
            onTap: (){
              controller.jumpToPage(0);
            },
              child: Icon(Icons.home,color: isDark ? Colors.white : Colors.black ,)), label: ""),
          BottomNavigationBarItem(icon: GestureDetector(
            onTap: (){
              controller.jumpToPage(1);
            },
              child: Icon(Icons.search,color: isDark ? Colors.white : Colors.black ,)), label: ""),
          BottomNavigationBarItem(
              icon: GestureDetector(
                onTap: (){controller.jumpToPage(2);
    }, child: Icon(Icons.add_box_outlined,color: isDark ? Colors.white : Colors.black ,)), label: ""),
          BottomNavigationBarItem(icon: GestureDetector(
              onTap: (){
                controller.jumpToPage(3);
              },
              child: Icon(Icons.favorite_border, color: isDark ? Colors.white : Colors.black)), label: ""),
          BottomNavigationBarItem(
              icon: GestureDetector(
                onTap: (){
                  controller.jumpToPage(4);
                },
                child: CircleAvatar(
                  foregroundColor: isDark ? Colors.white : Colors.grey,
                  radius: 15,
                  backgroundImage: AssetImage("asset/image/boy1.jpg"),
                ),
              ),
              label: ""),
        ],
      ),
    );
  }
}
