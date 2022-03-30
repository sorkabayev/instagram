import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram/pages/profile_page.dart';
import '../models/user_model.dart';
import '../services/data_service.dart';
import '../services/http_service.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key? key, this.controller}) : super(key: key);
  static const String id = 'my_search_page';
  PageController? controller;

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();
  List<User> user = [];
  List<User> followingUsers = [];
  bool isLoading = false;

  @override
  void initState(){
    super.initState();
    _apiSearchUsers("");
    _getFollowingUsers();
  }

  void _apiSearchUsers(String keyword) async{
    setState(() {
      isLoading = true;
    });
    await DataService.searchUsers(keyword).then((users) => _resSearchUser(users));
  }

  void _resSearchUser(List<User> users) {
    if(mounted) {
      setState(() {
        isLoading = false;
        user = users;
      });
    }
  }

  Future<void> _apiFollowUser(User someone) async{
    setState(() {
      isLoading = true;
    });
    await DataService.followUser(someone);
    setState(() {
      // someone.followed = true;
      isLoading = false;
    });
    await Network.POST(Network.API_PUSH, Network.bodyCreate(someone.device_token, someone.device_token)).then((value) {
      print(value);
    });

    await DataService.storePostsToMyFeed(someone);
  }

  Future<void> _apiUnFollowUser(User someone) async{
    setState(() {
      isLoading = true;
    });
    await DataService.unFollowUser(someone);
    setState(() {
      isLoading = false;
    });
    await DataService.removePostsFromMyFeed(someone);
  }

  void _getFollowingUsers() async{
    DataService.loadUser().then((value) {
      if(mounted) {
        setState(() {
          followingUsers;
        });
      }
    });
    // _sortList();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [

                    //#searchTextfield
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      height: 45,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey.withOpacity(0.2)
                      ),
                      child: TextField(
                        controller: searchController,
                        onChanged: (keyword) {
                          _apiSearchUsers(keyword);
                        },
                        decoration: const InputDecoration(
                            prefixIcon: Icon(CupertinoIcons.search, color: Colors.grey,),
                            border: InputBorder.none,
                            hintText: "Search",
                            hintStyle: TextStyle(color: Colors.grey)
                        ),
                      ),
                    ),

                    const SizedBox(height: 20,),

                    ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: user.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                            onTap: (){},
                            leading: Container(
                              padding: const EdgeInsets.all(2),
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  border: Border.all(width: 1.5, color: const Color.fromRGBO(193, 53, 132, 1))
                              ),
                              child: user[index].imageUrl == null ?const CircleAvatar(
                                radius: 22,
                                backgroundImage: AssetImage('assets/images/person_icon.png'),
                              ) : ClipRRect(
                                borderRadius: BorderRadius.circular(25),
                                child: CachedNetworkImage(
                                  height: 40,
                                  width: 40,
                                  fit: BoxFit.cover,
                                  imageUrl: user[index].imageUrl!,
                                  placeholder: (context, url) => const Image(image: AssetImage("assets/images/person_icon.png")),
                                  errorWidget: (context, url, error) => const Icon(Icons.error),
                                ),
                              ),
                            ),
                            title: Text(user[index].fullName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                            subtitle: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(user[index].fullName, style: const TextStyle(fontSize: 12, color: Colors.grey),),
                                const Text("Following", style: TextStyle(fontSize: 12, color: Colors.grey),)
                              ],
                            ),
                            trailing: Container(
                              height: 26,
                              width: 95,
                              decoration: BoxDecoration(
                                border: Border.all(width: 1, color: Colors.grey),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: MaterialButton(
                                height: 26,
                                onPressed: () async {
                                  if(user[index].followed){
                                    await _apiUnFollowUser(user[index]);
                                  }else{
                                    await _apiFollowUser(user[index]);
                                  }

                                  await Network.POST(Network.API_PUSH, Network.bodyCreate(user[index].device_token, user[index].fullName));
                                },
                                child: Text(user[index].followed ? 'Following' : 'Follow', style: const TextStyle(color: Colors.grey),),
                              ),
                            ),
                          );
                        }
                    ),

                  ],
                ),
              ),
              isLoading ? SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ) ) : const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}