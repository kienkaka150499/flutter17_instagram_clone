import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter17_instagram_clone/firebases/auth_method.dart';
import 'package:flutter17_instagram_clone/utils/colors.dart';
import 'package:flutter17_instagram_clone/utils/global_variables.dart';
import 'package:flutter17_instagram_clone/views/screen_layout.dart';
import 'package:flutter17_instagram_clone/views/singup_screen.dart';
import 'package:flutter17_instagram_clone/widgets/show_snackbar.dart';
import 'package:flutter17_instagram_clone/widgets/text_feild.dart';
import 'package:flutter_svg/svg.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isShowPassword = false;
  bool _isLoading = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void loginUser() async {
    setState(() {
      _isLoading = true;
    });

    String result = await AuthMethod().loginUser(
      email: _emailController.text,
      password: _passwordController.text,
    );

    if(result == 'success'){
      setState(() {
        _isLoading=false;
      });
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_)=>const ResponsiveLayout(),),
      );
    }else{
      setState(() {
        _isLoading=false;
      });
      showSnackBar(context, result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width>webScreenSize?500:double.infinity,
            height: MediaQuery.of(context).size.height,
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
                      isPassword: !_isShowPassword,
                    ),
                    Positioned(
                        right: 0,
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              _isShowPassword = !_isShowPassword;
                            });
                          },
                          icon: Icon(_isShowPassword
                              ? Icons.visibility
                              : Icons.visibility_off),
                        ))
                  ],
                ),
                SizedBox(
                  height: 40,
                  child: Row(
                    children: [
                      Expanded(child: Container()),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Forget Password?',
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () => loginUser(),
                  style: ButtonStyle(
                    fixedSize: MaterialStateProperty.all(
                      const Size(double.maxFinite, 40),
                    ),
                  ),
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: primaryColor,
                          ),
                        )
                      : const Text(
                          'Login',
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
                      "Don't have account?",
                      style: TextStyle(
                        color: primaryColor,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SignupScreen(),
                          ),
                        );
                      },
                      child: const Text('Sign up'),
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
    );
  }
}
