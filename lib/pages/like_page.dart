import 'package:flutter/material.dart';
import 'package:instagram/view/home_widget.dart';

import '../models/post_model.dart';
import '../services/data_service.dart';
import '../view/appBar_widget.dart';

class LikePage extends StatefulWidget {
  const LikePage({Key? key}) : super(key: key);
  static const String id = "likes_page";

  @override
  _LikePageState createState() => _LikePageState();
}

class _LikePageState extends State<LikePage> {
  bool isLoading = true;
  List<Post> items = [];

  @override
  void initState() {
    super.initState();
    _apiLoadLikes();
  }

  void _apiLoadLikes() async {
    setState(() {
      isLoading = true;
    });

    DataService.loadLikes().then((posts) => {
      _resLoadLikes(posts)
    });
  }

  void _resLoadLikes(List<Post> posts) {
    setState(() {
      items = posts;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: "Likes",),
      body: Stack(
        children: [
          ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                return HomeWidget(post: items[index], function: _apiLoadLikes, load: _apiLoadLikes,);
              }),

          if(isLoading) const Center(
            child: CircularProgressIndicator(),
          )
        ],
      ),
    );
  }
}