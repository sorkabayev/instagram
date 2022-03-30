// import 'dart:convert';
//
// import 'package:hive/hive.dart';
//
// import '../models/post_model.dart';
//
// class HiveDB{
//   static String DB_NAME = "Firebase";
//   static var box = Hive.box(DB_NAME);
//
//   static void storeNote(Post note) async{
//     box.put("note", note.toJson());
//   }
//
//   /// For Model Note ####################################################3#
//   static Post loadNote(){
//     var note = Post.fromJson(box.get("note") ?? {});
//     return note;
//   }
//
//   static void storeListNote(List<Post> notes){
//     List stringNote = notes.map((e) => jsonEncode(e.toJson())).toList();
//     box.put("note", stringNote);
//   }
//
//   static List<Post> loadListNote(){
//     List<String> stringNote = box.get("note") ?? [];
//     return stringNote.map((e) => Post.fromJson(jsonDecode(e))).toList();
//   }
//   ///#######################################################################
//
//
//   static Future<void> storeUid(StorageKeys key, String value) async{
//     await box.put(_getKey(key), value);
//   }
//
//   static Future<String?> loadUid(StorageKeys key) async{
//     return await box.get(_getKey(key));
//
//   }
//
//   static Future<void> removeUid(StorageKeys key)async{
//     await  box.delete(_getKey(key));
//   }
//
//   static String _getKey(StorageKeys key) {
//     switch(key) {
//       case StorageKeys.UID: return "uid";
//       case StorageKeys.FIRSTNAME: return "firstname";
//       case StorageKeys.LASTNAME: return "lastname";
//     }
//   }
//
//   static Future<void> removeNote()async{
//     box.delete("note");
//   }
//
//   static void removeAll(){
//     box.clear();
//   }
//
// }
//
//
//
// enum StorageKeys {
//   UID,
//   LASTNAME,
//   FIRSTNAME,
// }

