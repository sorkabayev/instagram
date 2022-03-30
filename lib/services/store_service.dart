import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StoreService{
  static final _storage = FirebaseStorage.instance.ref();
  static const folderPostImg = "post_image";
  static const folderUserImg = "user_image";


  static Future<String?> uploadImage(File? image,String folder) async{
   print(image.toString() + "aaaaaa");
   print(folder);
    String imgName = "image_" + DateTime.now().toString();
    Reference firebaseStorageRef = _storage.child(folder).child(imgName);
    TaskSnapshot taskSnapshot = await firebaseStorageRef.putFile(image!);
   final String imgUrl = await taskSnapshot.ref.getDownloadURL();
   print(taskSnapshot);
    return imgUrl;
  }
}