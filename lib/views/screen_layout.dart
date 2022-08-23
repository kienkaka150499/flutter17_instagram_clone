import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter17_instagram_clone/models/user_models.dart';
import 'package:flutter17_instagram_clone/providers/user_provider.dart';
import 'package:flutter17_instagram_clone/utils/colors.dart';
import 'package:flutter17_instagram_clone/utils/global_variables.dart';
import 'package:flutter17_instagram_clone/views/add_post_screen.dart';
import 'package:flutter17_instagram_clone/views/new_feed_screen.dart';
import 'package:flutter17_instagram_clone/views/profile_screen.dart';
import 'package:flutter17_instagram_clone/views/search_screen.dart';
import 'package:provider/provider.dart';

class ResponsiveLayout extends StatefulWidget {
  const ResponsiveLayout({Key? key}) : super(key: key);

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {
  UserModel? user;
  addData() async {
    UserProvider _userProvider = Provider.of(context,listen: false);
    await _userProvider.refreshUser();
    return user=_userProvider.getUser;
  }

  @override
  void initState() {
    // TODO: implement initState
    addData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: addData(),
      builder: (context,snap) {
        return !snap.hasData?const Center(
          child: CircularProgressIndicator(),
        ): LayoutBuilder(builder: (context, constrains) {
          return constrains.maxWidth > webScreenSize
              ? const WebScreenLayout()
              : const MobileScreenLayout();
        });
      }
    );
  }
}

class WebScreenLayout extends StatefulWidget {

  const WebScreenLayout({Key? key}) : super(key: key);

  @override
  State<WebScreenLayout> createState() => _WebScreenLayoutState();
}

class _WebScreenLayoutState extends State<WebScreenLayout> {
  PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        onPageChanged: (i) {
          setState(() {
            page = i;
          });
        },
        children: [
          const NewFeedScreen(),
          const SearchScreen(),
          const PostScreen(),
          const Center(child: Text('This is Notification')),
          ProfileScreen(uid: context.read<UserProvider>().getUser.uid,),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: mobileBackgroundColor,
        selectedItemColor: primaryColor,
        unselectedItemColor: secondaryColor,
        currentIndex: page,
        onTap: (i) {
          pageController.jumpToPage(i);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
            ),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add_circle,
            ),
            label: 'Post',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.notifications,
            ),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({Key? key}) : super(key: key);

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  PageController pageController = PageController();
  var _page = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        onPageChanged: (i) {
          setState(() {
            _page = i;
          });
        },
        children: [
          const NewFeedScreen(),
          const SearchScreen(),
          const PostScreen(),
          const Center(child: Text('This is Notification')),
          ProfileScreen(uid: context.read<UserProvider>().getUser.uid,),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: mobileBackgroundColor,
        selectedItemColor: primaryColor,
        unselectedItemColor: secondaryColor,
        currentIndex: _page,
        onTap: (i) {
          pageController.jumpToPage(i);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
            ),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add_circle,
            ),
            label: 'Post',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.notifications,
            ),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
