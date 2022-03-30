import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram/services/store_service.dart';
import '../models/post_model.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/data_service.dart';
import '../view/appBar_widget.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    Key? key,
  }) : super(key: key);
  static const String id = "profile_page";

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isLoading = false;
  List<Post> items = [];
  File? _image;
  User? user;
  int countPosts = 0;

  @override
  void initState() {
    super.initState();
    _apiLoadUser();
    _apiLoadPost();
  }

  // for user image
  _imgFromCamera() async {
    XFile? image = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 50);

    setState(() {
      _image = File(image!.path);
    });
    _apiChangePhoto();
  }

  _imgFromGallery() async {
    XFile? image = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _image = File(image!.path);
    });
    _apiChangePhoto();
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: Icon(Icons.photo_library),
                    title: Text('Photo Library'),
                    onTap: () {
                      _imgFromGallery();
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: Icon(Icons.photo_camera),
                  title: Text('Camera'),
                  onTap: () {
                    _imgFromCamera();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }

  // for load user
  void _apiLoadUser() async {
    setState(() {
      isLoading = true;
    });
    DataService.loadUser().then((value) => _showUserInfo(value));
  }

  void _showUserInfo(User user) {
    if (mounted) {
      setState(() {
        this.user = user;
        isLoading = false;
      });
    }
  }

  // for edit user
  void _apiChangePhoto() {
    if (_image == null) return;

    setState(() {
      isLoading = true;
    });
    StoreService.uploadImage(_image!, StoreService.folderUserImg)
        .then((value) => _apiUpdateUser(value!));
  }

  void _apiUpdateUser(String imgUrl) async {
    setState(() {
      isLoading = false;
      user!.imageUrl = imgUrl;
    });
    await DataService.updateUser(user!);
  }

  // for load post
  void _apiLoadPost() {
    DataService.loadPosts().then((posts) => {_resLoadPost(posts)});
  }

  void _resLoadPost(List<Post> posts) {
    setState(() {
      items = posts;
      countPosts = posts.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar(
          title: "Profile",
          icon: const Icon(
            Icons.exit_to_app,
            color: Colors.black87,
          ),
          onPressed: () {
            showDialog(
                context: context,
                builder: (_) {
                  return AlertDialog(
                    title: const Text("Do yo want to Log Out"),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Cancel")),
                      TextButton(
                          onPressed: () {
                            AuthService.signOutUser(context);
                          },
                          child: const Text("Log Out")),
                    ],
                  );
                });
          }),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // #avatar
              Padding(
                padding: const EdgeInsets.only(left: 12, right: 12),
                child: Row(
                  children: [
                    Stack(
                      children: [
                        Container(
                          height: 75,
                          width: 75,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(
                                  color: Colors.purpleAccent, width: 2)),
                          padding: const EdgeInsets.all(2),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(75),
                            child: user?.imageUrl == null ||
                                    user!.imageUrl!.isEmpty
                                ? const Image(
                                    image: AssetImage("asset/image/ins.webp"),
                                    height: 50,
                                    width: 50,
                                    fit: BoxFit.cover,
                                  )
                                : Image(
                                    image: NetworkImage(user!.imageUrl!),
                                    height: 50,
                                    width: 50,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                        Container(
                          height: 77.5,
                          width: 77.5,
                          alignment: Alignment.bottomRight,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: IconButton(
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                onPressed: () {
                                  _showPicker(context);
                                },
                                icon: const Icon(
                                  Icons.add_circle,
                                  color: Colors.purple,
                                )),
                          ),
                        )
                      ],
                    ),
                    // #statistics
                    Expanded(
                      child: Column(children: [
                        Text(
                          countPosts.toString(),
                          style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        const Text(
                          "Post",
                          style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                              fontSize: 14),
                        )
                      ]),
                    ),
                    Expanded(
                      child: Column(children: [
                        Text(
                          user == null ? "0" : user!.followersCount.toString(),
                          style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        const Text(
                          "Folowers",
                          style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                              fontSize: 14),
                        )
                      ]),
                    ),
                    Expanded(
                      child: Column(children: [
                        Text(
                          user == null ? "0" : user!.followingCount.toString(),
                          style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        const Text(
                          "Following",
                          style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                              fontSize: 14),
                        )
                      ]),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              // #name
              Text(
                user?.fullName == null ? "" : user!.fullName,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 20,
              ),

              // #posts
              DefaultTabController(
                length: 2,
                child: TabBar(
                  tabs: [
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          CupertinoIcons.table,
                          color: Colors.black,
                        )),
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          CupertinoIcons.person_crop_rectangle,
                          color: Colors.black,
                        )),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 1,
                      crossAxisSpacing: 1),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return CachedNetworkImage(
                      // height: MediaQuery.of(context).size.height * 0.12,
                      // width: MediaQuery.of(context).size.width * 0.28,
                      fit: BoxFit.cover,
                      imageUrl: items[index].postImage,
                      placeholder: (context, url) => Container(
                        color: Colors.grey,
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    );
                  },
                ),
              )
            ],
          ),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(),
            )
        ],
      ),
    );
  }
}
