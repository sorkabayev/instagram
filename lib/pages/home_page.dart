
import 'package:flutter/material.dart';
import 'package:instagram/view/home_widget.dart';
import '../models/post_model.dart';
import '../services/data_service.dart';
import '../view/appBar_widget.dart';

class HomePage extends StatefulWidget {
  static const String id = "feed_page";
  PageController? pageController;

  HomePage({this.pageController, Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = true;
  List<Post> items = [];

  @override
  void initState() {
    super.initState();
    _apiLoadFeeds();
  }

  void _apiLoadFeeds() async {
    setState(() {
      isLoading = true;
    });

    DataService.loadFeeds().then((posts) => {
      _resLoadFeeds(posts)
    });
  }

  void _resLoadFeeds(List<Post> posts) {
    setState(() {
      isLoading = false;
      items = posts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
          title: "Instagram",
          icon: const Icon(Icons.camera_alt, color: Colors.black,),
          onPressed: () {
            widget.pageController!.jumpToPage(2);
          }),
      body: Stack(
        children: [
          ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) => HomeWidget(post: items[index]),
          ),

          if(isLoading) const Center(
            child: CircularProgressIndicator(),
          )
        ],
      ),
    );
  }
}