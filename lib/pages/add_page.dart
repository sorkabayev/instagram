import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram/pages/main_page.dart';
import 'package:instagram/services/store_service.dart';
import 'package:instagram/view/appBar_widget.dart';

import '../models/post_model.dart';
import '../services/data_service.dart';

class AddPage extends StatefulWidget {
  const AddPage({Key? key,}) : super(key: key);

  static const String id = "add_page";

  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  TextEditingController captionControler = TextEditingController();

  int currentIndex = 2;

  ///Image Picker
  File? _image;
  bool isLoading = false;

  Future<void> getImage({required ImageSource source}) async {
    final image = (await ImagePicker().pickImage(source: source));
    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
    }
  }

  ///################################################################

  void _uploadPost(){
    String caption = captionControler.text.trim().toString();
    print(caption);
    if(caption.isEmpty||_image == null){ print("aa"); return;}
    //send post to server
    _apiPostImage();
  }

  void _apiPostImage(){
    setState(() {
      isLoading = true;
    });

    StoreService.uploadImage(_image!, StoreService.folderPostImg).then((imageUrl) {
      print("aaa");
      _resPostImage(imageUrl!);
    });
  }

  void _resPostImage(String imageUrl) {
    String caption = captionControler.text.toString();
    Post post = Post(caption: caption,postImage: imageUrl);
    _apiStorePost(post);
  }

 void _apiStorePost(Post post) async {
   Post posted = await DataService.storePost(post);
    // Post to feeds folder

    await DataService.storeFeed(posted).then((value) => {
      _moveToFeed(),
    });
  }

  void _moveToFeed() {
    setState(() {
      isLoading = false;
    });
    Navigator.pushReplacementNamed(context, MainPage.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
        onPressed: _uploadPost,
        title: "Upload",
        icon: const Icon(
          Icons.add_photo_alternate_outlined,
          color: Colors.purple,
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  _image == null
                      ? GestureDetector(
                          onTap: () {
                            _showPicker();
                          },
                          child: Container(
                            color: Colors.grey.shade300,
                            child: const Icon(
                              Icons.add_photo_alternate_outlined,
                              size: 40,
                            ),
                            height: MediaQuery.of(context).size.width,
                            width: double.infinity,
                          ),
                        )
                      : SizedBox(
                          height: MediaQuery.of(context).size.width,
                          width: double.infinity,
                          child: Image.file(
                            File(_image!.path),
                            fit: BoxFit.cover,
                          ),
                        ),
                  Container(
                      margin: const EdgeInsets.only(left: 10, right: 10),
                      height: MediaQuery.of(context).size.width - 5,
                      width: double.infinity,
                      child: TextField(
                        controller: captionControler,
                        decoration: const InputDecoration(hintText: "Caption"),
                      ))
                ],
              ),
            ),
          ),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(color: Colors.pinkAccent,),
            )
        ],
      ),
    );
  }

  void _showPicker() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: SizedBox(
              height: 100,
              child: Wrap(
                children: <Widget>[
                  ListTile(
                      leading: const Icon(Icons.photo_library),
                      title: const Text('Photo Library'),
                      onTap: () {
                        getImage(source: ImageSource.gallery);
                        Navigator.pop(context);
                      }),
                  ListTile(
                    leading: const Icon(Icons.photo_camera),
                    title: const Text('Camera'),
                    onTap: () {
                      getImage(source: ImageSource.camera);
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }
}
