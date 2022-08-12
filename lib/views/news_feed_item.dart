import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter17_instagram_clone/models/user_models.dart';
import 'package:flutter17_instagram_clone/views/profile_screen.dart';
import 'package:intl/intl.dart';
import '../firebases/firestore_method.dart';
import '../utils/colors.dart';
import '../utils/global_variables.dart';
import '../widgets/show_snackbar.dart';
import 'comment_screen.dart';

class NewsFeedItem extends StatefulWidget {
  Map<String, dynamic> snapshot;
  UserModel user;

  NewsFeedItem({Key? key, required this.snapshot, required this.user})
      : super(key: key);

  @override
  State<NewsFeedItem> createState() => _NewsFeedItemState();
}

class _NewsFeedItemState extends State<NewsFeedItem> {
  final TextEditingController _commentController = TextEditingController();
  int commentCount = 0;

  fetchCommentCount() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snapshot['postId'])
          .collection('comments')
          .get();
      commentCount = snap.docs.length;
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return commentCount;
  }

  void postComment(
      String uid, String name, String profileImage, String comment) async {
    try {
      String result = await FirestoreMethod().postComment(
          widget.snapshot['postId'], comment, uid, name, profileImage);
      if (result != 'success') {
        showSnackBar(context, result);
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  fetchDeletePost() async {
    try {
      await FirestoreMethod().deletePost(widget.snapshot['postId']);
    } catch (e) {
      e.toString();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    fetchCommentCount();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _width = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: _width > webScreenSize ? _width * 0.3 : 0,
        vertical: _width > webScreenSize ? 15 : 0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: Alignment.topCenter,
            children: [
              InkWell(
                onDoubleTap: () {
                  if (!widget.snapshot['likes'].contains(widget.user.uid)) {
                    FirestoreMethod().likePost(
                      widget.snapshot['postId'],
                      widget.user.uid,
                      widget.snapshot['likes'],
                    );
                  }
                },
                child: SizedBox(
                  width: _width,
                  height: _width > webScreenSize ? _width * 0.4 : _width,
                  child: Image.network(
                    widget.snapshot['photoUrl'],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                    top: 5, left: _width > webScreenSize ? 10 : 0),
                width: _width * 0.9,
                height: 50,
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  ProfileScreen(uid: widget.snapshot['uid']),
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            SizedBox(
                              width: 50,
                              height: 50,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(25),
                                child: Image.network(
                                  widget.snapshot['profileImage'],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      widget.snapshot['username'].toString(),
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(widget.snapshot['caption']),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    IconButton(
                      padding: const EdgeInsets.all(0),
                      icon: const Icon(Icons.more_horiz),
                      onPressed: () {
                        if (widget.user.uid == widget.snapshot['uid']) {
                          showDialog(
                              context: context,
                              builder: (_) {
                                return SimpleDialog(
                                  title: const Text('Option'),
                                  children: [
                                    SimpleDialogOption(
                                      padding: const EdgeInsets.all(20),
                                      onPressed: () {
                                        FirestoreMethod().deletePost(
                                            widget.snapshot['postId']);
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Delete Post'),
                                    ),
                                  ],
                                );
                              });
                        }
                        //else if()
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 30,
            child: Row(
              children: [
                IconButton(
                  icon: widget.snapshot['likes'].contains(widget.user.uid)
                      ? const Icon(
                          Icons.favorite,
                          color: Colors.pink,
                        )
                      : const Icon(Icons.favorite_border),
                  onPressed: () {
                    FirestoreMethod().likePost(
                      widget.snapshot['postId'],
                      widget.user.uid,
                      widget.snapshot['likes'],
                    );
                  },
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.comment_outlined),
                  alignment: AlignmentDirectional.centerStart,
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.send),
                  alignment: AlignmentDirectional.centerStart,
                ),
                Expanded(child: Container()),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.bookmark_border),
                  alignment: AlignmentDirectional.centerEnd,
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CommentScreen(
                    postId: widget.snapshot['postId'],
                  ),
                ),
              );
            },
            child: FutureBuilder(
                future: fetchCommentCount(),
                builder: (context, snap) {
                  return Container(
                    margin: const EdgeInsets.only(top: 8, left: 8),
                    height: 25,
                    child: Text(
                      "${widget.snapshot['likes'].length} likes, ${snap.data} comments",
                    ),
                  );
                }),
          ),
          Container(
            height: 30,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 25,
                  height: 25,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.5),
                    child: Image.network(
                      widget.user.photoUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 10),
                    child: TextField(
                      controller: _commentController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        hintText: 'Add comment',
                      ),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: ()
                  {
                    FirestoreMethod().postComment(
                        widget.snapshot['postId'],
                        _commentController.text,
                        widget.user.uid,
                        widget.user.username,
                        widget.user.photoUrl);
                    _commentController.text='';
                  },

                  child: const Text(
                    'Post',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.all(8),
            height: 15,
            child: Text(
              DateFormat.yMMMd()
                  .format(widget.snapshot['datePublished'].toDate()),
              style: const TextStyle(
                color: secondaryColor,
              ),
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }
}
