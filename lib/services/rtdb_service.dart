import 'package:firebase_database/firebase_database.dart';
import '../models/post_model.dart';

class RTDBService {
  static final DatabaseReference _database = FirebaseDatabase.instance.ref();
  static const String apiPost = "post";

  // Store post
  static Future<Stream<DatabaseEvent>> storePost(Post post) async {
    print(post.toJson());
    _database.child(apiPost).push().set(post.toJson());
    return _database.onChildAdded;
  }
// Load post
  static Future<List<Post>> loadPost(String id) async {
    List<Post> items= [];
    Query query = _database.child(apiPost).orderByChild("userid").equalTo(id);
    DatabaseEvent response = await query.once();
    print("response: ${response.toString()}");
    items = response.snapshot.children.map((json) => Post.fromJson(Map<String, dynamic>.from(json.value as Map))).toList();
    for (int i = 0; i < response.snapshot.children.length; i++) {
      items[i].uid = response.snapshot.children.elementAt(i).key!;
    }
    return items;
  }
// Update Post
  static Future<Stream<DatabaseEvent>> update(String id, Post post) async {
    _database.child("post").child(id).update(post.toJson());
    return _database.onChildChanged;
  }

  // Delete Post
  static Future<Stream<DatabaseEvent>> delete(String key) async {
    _database.child("post").child(key).remove();
    return _database.onChildRemoved;
  }

  //Search User


}