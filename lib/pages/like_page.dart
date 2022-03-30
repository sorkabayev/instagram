import 'package:flutter/material.dart';
import 'package:instagram/services/data_service.dart';
import 'package:instagram/view/appBar_widget.dart';

import '../models/post_model.dart';
class LikePage extends StatefulWidget {
  const LikePage({Key? key}) : super(key: key);

  static const String id = "like_page";

  @override
  _LikePageState createState() => _LikePageState();
}

class _LikePageState extends State<LikePage> {

  bool isLoading = true;
  List<Post> items = [];
  int currentIndex = 3;

  void _apiLoadLikes(){
    setState(() {
      isLoading = false;
    });

    DataService.loadFeeds();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: "Likes"),
    );
  }
}
