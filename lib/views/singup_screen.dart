import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter17_instagram_clone/firebases/auth_method.dart';
import 'package:flutter17_instagram_clone/utils/colors.dart';
import 'package:flutter17_instagram_clone/utils/picker_image.dart';
import 'package:flutter17_instagram_clone/views/login_screen.dart';
import 'package:flutter17_instagram_clone/views/screen_layout.dart';
import 'package:flutter17_instagram_clone/widgets/show_snackbar.dart';
import 'package:flutter17_instagram_clone/widgets/text_feild.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

import '../utils/global_variables.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool isShowPassword = false;
  Uint8List? _image;
  bool _isLoading = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();


  // final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
  }

  Future<Uint8List>? loadImage() async {
    var image = await rootBundle.load('assets/images/default_image.png');
    return _image = image.buffer.asUint8List();
  }

  void selectImage() async {
    Uint8List image = await pickImage(ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  void signupUser() async {
    setState(() {
      _isLoading = true;
    });

    String result = await AuthMethod().signUpUser(
      username: _usernameController.text,
      email: _emailController.text,
      password: _passwordController.text,
      file: _image==null?(await loadImage()!):_image!,
    );

    if (result == 'success') {
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const ResponsiveLayout()),
      // Navigator.of(context).pushReplacement(
      //   MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } else {
      setState(() {
        _isLoading = false;
      });

      showSnackBar(context, result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width>webScreenSize?500:double.infinity,
              height: MediaQuery.of(context).size.height*.95,
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(),
                  ),
                  SvgPicture.asset(
                    'assets/images/instagram_icon.svg',
                    color: primaryColor,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Stack(
                    children: [
                      _image == null
                          ? const CircleAvatar(
                              radius: 64,
                              backgroundImage: AssetImage('assets/images/default_image.png'),
                            )
                          : CircleAvatar(
                              radius: 64,
                              backgroundImage: MemoryImage(_image!),
                            ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                            color: mobileBackgroundColor,
                            borderRadius: BorderRadius.circular(17.5),
                          ),
                          child: IconButton(
                            onPressed: () => selectImage(),
                            icon: const Icon(Icons.add_a_photo),
                            padding: const EdgeInsets.all(0),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFeildInput(
                    controller: _usernameController,
                    textInputType: TextInputType.text,
                    hintText: 'Username',
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFeildInput(
                    controller: _emailController,
                    textInputType: TextInputType.emailAddress,
                    hintText: 'Email',
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Stack(
                    children: [
                      TextFeildInput(
                        controller: _passwordController,
                        textInputType: TextInputType.text,
                        hintText: 'Password',
                        isPassword: !isShowPassword,
                      ),
                      Positioned(
                          right: 0,
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                isShowPassword = !isShowPassword;
                              });
                            },
                            icon: Icon(isShowPassword
                                ? Icons.visibility
                                : Icons.visibility_off),
                          ))
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () => signupUser(),
                    style: ButtonStyle(
                      fixedSize: MaterialStateProperty.all(
                        const Size(double.maxFinite, 40),
                      ),
                    ),
                    child: _isLoading?const Center(
                      child: CircularProgressIndicator(
                        color: primaryColor,
                      ),
                    ):const Text(
                      'Sign up',
                      style: TextStyle(
                        color: primaryColor,
                      ),
                    ),
                  ),
                  Expanded(child: Container()),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "You already have account?",
                        style: TextStyle(
                          color: primaryColor,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LoginScreen(),
                            ),
                          );
                        },
                        child: const Text('Login'),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
