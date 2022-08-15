import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter17_instagram_clone/firebases/firestore_method.dart';
import 'package:flutter17_instagram_clone/models/user_models.dart';
import 'package:flutter17_instagram_clone/providers/user_provider.dart';
import 'package:flutter17_instagram_clone/utils/colors.dart';
import 'package:flutter17_instagram_clone/utils/global_variables.dart';
import 'package:flutter17_instagram_clone/views/news_feed_item.dart';
import 'package:flutter17_instagram_clone/widgets/show_snackbar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'comment_screen.dart';

class NewFeedScreen extends StatefulWidget {
  const NewFeedScreen({Key? key}) : super(key: key);

  @override
  State<NewFeedScreen> createState() => _NewFeedScreenState();
}

class _NewFeedScreenState extends State<NewFeedScreen> {
  
  bool isLike = false;

  @override
  void initState() {
    super.initState();
  }

  void postComment(String uid, String name, String profileImage,String postId, String comment) async {
    try {
      String result = await FirestoreMethod().postComment(
          postId, comment, uid, name, profileImage);
      if (result != 'success') {
        showSnackBar(context, result);

      }
      setState(() {

      });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    
    UserModel user = context.watch<UserProvider>().getUser;
    // if(user == null){
    //   return const Center(
    //     child: CircularProgressIndicator(),
    //   );
    // }
    return Scaffold(
      backgroundColor:
          width > webScreenSize ? webBackgroundColor : mobileBackgroundColor,
      appBar: width > webScreenSize
          ? null
          : AppBar(
              title: SvgPicture.asset(
                'assets/images/instagram_icon.svg',
                color: primaryColor,
                fit: BoxFit.cover,
                height: 50,
              ),
              actions: const [
                Icon(Icons.messenger_outline),
              ],
              backgroundColor: mobileBackgroundColor,
            ),
      body: SafeArea(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('posts').snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (_, index) {
                return NewsFeedItem(
                    snapshot:snapshot.data!.docs[index].data(), user:user);
              },
            );
          },
        ),
      ),
    );
  }
}
