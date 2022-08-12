import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter17_instagram_clone/firebases/firestore_method.dart';
import 'package:flutter17_instagram_clone/models/user_models.dart';
import 'package:flutter17_instagram_clone/providers/user_provider.dart';
import 'package:flutter17_instagram_clone/utils/colors.dart';
import 'package:flutter17_instagram_clone/widgets/show_snackbar.dart';
import 'package:flutter17_instagram_clone/widgets/text_feild.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CommentScreen extends StatefulWidget {
  final String postId;

  const CommentScreen({Key? key, required this.postId}) : super(key: key);

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final TextEditingController commentController = TextEditingController();
  late UserModel user = context.watch<UserProvider>().getUser;
  late double _width;

  void postComment(
      String uid, String name, String profileImage, String comment) async {
    try {
      String result = await FirestoreMethod()
          .postComment(widget.postId, comment, uid, name, profileImage);
      if (result != 'success') {
        showSnackBar(context, result);
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  fetchComment() async {
    QuerySnapshot snap = await FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.postId)
        .collection('comments')
        .get();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    commentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        leading: IconButton(
          onPressed: () {
            commentController.text = '';
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('Comment'),
        actions: [
          TextButton(
            onPressed: () {
              postComment(user.uid, user.username, user.photoUrl,
                  commentController.text);
              commentController.text = '';
            },
            child: const Text(
              'Post',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 50,
            width: _width,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundImage: NetworkImage(user.photoUrl),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 10),
                  width: _width * 0.8,
                  height: 45,
                  child: TextFeildInput(
                    controller: commentController,
                    textInputType: TextInputType.text,
                    hintText: 'write comment here',
                  ),
                )
              ],
            ),
          ),
          const Divider(),
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('posts')
                  .doc(widget.postId)
                  .collection('comments')
                  .snapshots(),
              builder:
                  (_, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (_, index) {
                        return Container(
                          margin: const EdgeInsets.all(10),
                          width: _width,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundImage: NetworkImage(
                                    snap.data!.docs[index]['profileImage']),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    padding: const EdgeInsets.all(5),
                                    width: _width - 80,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.blueGrey.withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      snap.data!.docs[index]['comment'],
                                      style: const TextStyle(fontSize: 15),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Text(
                                      DateFormat.yMMMd().format(
                                        snap.data!.docs[index]['datePublished']
                                            .toDate(),
                                      ),
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (_, index) => const Divider(),
                      itemCount: snap.data!.docs.length),
                );
              }),
        ],
      ),
    );
  }
}
