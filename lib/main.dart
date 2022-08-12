import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter17_instagram_clone/providers/user_provider.dart';
import 'package:flutter17_instagram_clone/utils/colors.dart';
import 'package:flutter17_instagram_clone/views/login_screen.dart';
import 'package:flutter17_instagram_clone/views/screen_layout.dart';
import 'package:provider/provider.dart';
import 'package:flutter17_instagram_clone/firebases/auth_method.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UserProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: mobileBackgroundColor,
        ),
        // home: ResponsiveLayout(),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.userChanges(),
          builder: (_, snapshot) {
            //check đã login hay chưa
            if (snapshot.connectionState==ConnectionState.active) {
              // đã login:
              if (snapshot.hasData) {
                return const ResponsiveLayout();
              } else {
                // co loi
                if (snapshot.hasError) {
                  return Center(
                    child: Text('${snapshot.error}'),
                  );
                }
              }
            }
            //đang chờ connection
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            // chưa login hoặc đã logout
            return const LoginScreen();
          },
        ),
      ),
      //   return MaterialApp(
      //     debugShowCheckedModeBanner: false,
      //     theme: ThemeData.dark().copyWith(
      //       scaffoldBackgroundColor: mobileBackgroundColor,
      //     ),
      //     // home: ResponsiveLayout(),
      //     home: const LoginScreen(),
    );
  }
}
