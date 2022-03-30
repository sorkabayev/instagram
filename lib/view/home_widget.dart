import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram/services/utils.dart';

import '../models/post_model.dart';
import '../services/data_service.dart';
class HomeWidget extends StatefulWidget {
 final Post post;
 final Function? function;
 final Function? load;
  const HomeWidget({required this.post,this.function, Key? key, this.load,}) : super(key: key);

  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {

  bool isLoading = false;

  void _apiPostLike(Post post) async {

    setState(() {
      isLoading = true;
    });
    await DataService.likePost(post, true);
    if(mounted) {
      setState(() {
        isLoading = false;
        post.isLiked = true;
      });
    }
  }

  void _apiUnPostLike(Post post) async {
    setState(() {
      isLoading = true;
    });
    await DataService.likePost(post, false);
    setState(() {
      isLoading = false;
      post.isLiked = false;
    });
    if(widget.function != null) {
      widget.function!();
    }
  }

  void updateLike() {
    if(widget.post.isLiked) {
      _apiUnPostLike(widget.post);
    } else {
      _apiPostLike(widget.post);
    }
  }

  void deletePost(Post post) async {
    bool result = await Utils.dialogCommon(context, "Instagram Clone", "Do yu want to remove this post?", false);

    if(result) {
      setState(() {
        isLoading = true;
      });

      await DataService.removePost(post);

      setState(() {
        isLoading = false;
      });

      if(widget.load != null) {
        widget.load!();
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width:MediaQuery.of(context).size.width,
      child: Column(
        children: [
          const Divider(),
          ListTile(
            leading: CircleAvatar(
              radius: 20,
              child: widget.post.imageUser != null ? CachedNetworkImage(
                height: 40,
                imageUrl: widget.post.imageUser!,
                placeholder: (context, url) => const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ) : const Image(image: AssetImage("asset/image/ins.webp"),fit: BoxFit.cover,),
            ),
            title: Text(widget.post.fullName,style: const TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold),),
            subtitle: Text(Utils.getMonthDayYear(widget.post.createdDate)),
            trailing: IconButton(icon: const Icon(Icons.more_horiz,color: Colors.black,), onPressed: () {
            },),
          ),
          CachedNetworkImage(
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
            imageUrl: widget.post.postImage,
            placeholder: (context, url) => Container(color: Colors.grey,),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
          Row(
            children: [
              IconButton(onPressed: updateLike, icon: Icon(widget.post.isLiked ? Icons.favorite : Icons.favorite_border,color: widget.post.isLiked ?  Colors.red: Colors.black, size: 27.5,)),
              IconButton(onPressed: (){}, icon: const Icon(CupertinoIcons.chat_bubble,color: Colors.black,)),
              IconButton(onPressed: (){}, icon: const Icon(CupertinoIcons.paperplane,color: Colors.black,)),
            ],
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
              child: Text(widget.post.caption),
            ),
          )
        ],
      ),
    );
  }
}
