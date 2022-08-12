import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter17_instagram_clone/firebases/firestore_method.dart';
import 'package:flutter17_instagram_clone/providers/user_provider.dart';
import 'package:flutter17_instagram_clone/utils/colors.dart';
import 'package:flutter17_instagram_clone/utils/global_variables.dart';
import 'package:flutter17_instagram_clone/views/login_screen.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  String uid;

  ProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // late UserModel user;
  late double _width;
  late double _height;
  late int postCount = 0;

  getPostCount() async {
    var postSnapshot = await FirebaseFirestore.instance
        .collection('posts')
        .where('uid', isEqualTo: widget.uid)
        .get();
    postCount = postSnapshot.docs.length;
    return postCount;
  }

  @override
  Widget build(BuildContext context) {
    // user = context.watch<UserProvider>().getUser;
    _width = MediaQuery.of(context).size.width;
    _height = MediaQuery.of(context).size.height;
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(widget.uid)
            .snapshots(),
        builder: (context,
            AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              title: Text(snapshot.data!['username']),
            ),
            body: SafeArea(
              child: ListView(
                children: [
                  SizedBox(
                    width: _width,
                    height: 100,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 40,
                                backgroundImage:
                                    NetworkImage(snapshot.data!['photoUrl']),
                              ),
                              Text(snapshot.data!['email']),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      children: [
                                        FutureBuilder(
                                            future: getPostCount(),
                                            builder: (context, snap) {
                                              if (snap.hasData) {
                                                return Text(
                                                    snap.data!.toString());
                                              }
                                              return Text(postCount.toString());
                                            }),
                                        const Text('posts'),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Text(
                                          snapshot.data!['followers'].length
                                              .toString(),
                                        ),
                                        const Text('followers'),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Text(
                                          snapshot.data!['following'].length
                                              .toString(),
                                        ),
                                        const Text('following'),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              widget.uid ==
                                      context.watch<UserProvider>().getUser.uid
                                  ? InkWell(
                                      onTap: () {
                                        FirebaseAuth.instance.signOut();
                                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>const LoginScreen(),),);
                                      },
                                      child: Container(
                                        width: 150,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          color: secondaryColor,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: const Center(
                                            child: Text(
                                          'Logout',
                                          style: TextStyle(color: Colors.black),
                                        )),
                                      ),
                                    )
                                  : InkWell(
                                      onTap: () {
                                        FirestoreMethod().followUser(
                                          FirebaseAuth
                                              .instance.currentUser!.uid,
                                          widget.uid,
                                        );
                                        setState(() {});
                                      },
                                      child: Container(
                                        width: 150,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          color: secondaryColor,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: snapshot.data!['followers']
                                                .contains(context
                                                    .watch<UserProvider>()
                                                    .getUser
                                                    .uid)
                                            ? const Center(
                                                child: Text(
                                                  'unfollow',
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                ),
                                              )
                                            : const Center(
                                                child: Text(
                                                  'follow',
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                ),
                                              ),
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: double.maxFinite,
                    child: FutureBuilder(
                        future: FirebaseFirestore.instance
                            .collection('posts')
                            .where('uid', isEqualTo: widget.uid)
                            .get(),
                        builder: (context, snap) {
                          if (snap.hasData) {
                            return GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: _width > webScreenSize ? 5 : 3,
                                crossAxisSpacing: 1,
                                mainAxisSpacing: 1,
                              ),
                              itemBuilder: (context, index) {
                                return Image.network(
                                  (snap.data! as dynamic).docs[index]
                                      ['photoUrl'],
                                  fit: BoxFit.cover,
                                );
                              },
                              itemCount: postCount,
                            );
                          }
                          return Container();
                        }),
                  )
                ],
              ),
            ),
          );
        });
  }
}
