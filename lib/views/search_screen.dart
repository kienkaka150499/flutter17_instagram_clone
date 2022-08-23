import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter17_instagram_clone/utils/colors.dart';
import 'package:flutter17_instagram_clone/utils/global_variables.dart';
import 'package:flutter17_instagram_clone/views/profile_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                width: width,
                height: 56,
                decoration: BoxDecoration(
                  color: searchBackgroundColor,
                  borderRadius: BorderRadius.circular(13.5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Icon(Icons.search),
                    Container(
                      width: width * 0.7,
                      child: TextField(
                        controller: searchController,
                        onChanged: (value) {
                          setState(() {});
                        },
                        decoration: const InputDecoration(
                            border: InputBorder.none, hintText: 'Search'),
                        cursorColor: primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(),
              FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .where('username',
                    isGreaterThanOrEqualTo: searchController.text)
                    .get(),
                builder: (_, snap) {
                  if (!snap.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  var users = (snap.data! as dynamic).docs;
                  return Container(
                    width: width,
                    height: height*0.85,
                    child: ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (_, index) {
                        return GestureDetector(
                          onTap: () => Navigator.push(context, MaterialPageRoute(
                            builder: (_) =>
                                ProfileScreen(uid: users[index]['uid']),),),
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            child: ListTile(
                              leading: CircleAvatar(
                                radius: 40,
                                backgroundImage: NetworkImage(users[index]['photoUrl']),
                              ),
                              title: Text(users[index]['username']),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
