import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hue_accommodation/constants/route_name.dart';
import 'package:hue_accommodation/view_models/chat_model.dart';
import 'package:hue_accommodation/view_models/notification_model.dart';
import 'package:hue_accommodation/view_models/user_model.dart';
import 'package:hue_accommodation/views/login_register/auth_service.dart';
import 'package:provider/provider.dart';

import '../../view_models/fcmToken_model.dart';
import '../components/slide_route.dart';
import 'choose_role.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isPasswordVisible = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late String email;
  late String password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [appBar(context), login(context), loginGoogle(context)],
          ),
        ),
      ),
    );
  }

  Widget appBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(children: [
            Image.asset('assets/images/loginImage.png'),
            Positioned(
              left: 0,
              top: 0,
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10)),
                child: const Center(
                  child: Icon(Icons.arrow_back_outlined),
                ),
              ),
            )
          ]),
          Center(
            child: Text(
              'Login',
              style: GoogleFonts.readexPro(
                  fontSize: 35, fontWeight: FontWeight.w500),
            ),
          )
        ],
      ),
    );
  }

  Widget login(BuildContext context) {
    return Consumer4<UserModel,NotificationModel,ChatModel,FcmTokenModel>(
      builder: (context, userProvider,notificationProvider,chatProvider,fcmTokenProvider, child) => Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0, right: 30, left: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      '@',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 28,
                          color: Colors.grey),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: TextFormField(
                        validator: (value) {
                          // add email validation
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }

                          bool emailValid = RegExp(r"""
^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+""")
                              .hasMatch(value);
                          if (!emailValid) {
                            return 'Please enter a valid email';
                          }
                          email = value;
                          return null;
                        },
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey.withOpacity(0.5)),
                          ),
                          hintText: 'Enter your email',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 100,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(Icons.lock_outline_rounded,
                        size: 30, color: Colors.grey),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }

                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          password = value;
                          return null;
                        },
                        obscureText: !_isPasswordVisible,
                        decoration: InputDecoration(
                            hintText: 'Enter your password',
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.grey.withOpacity(0.5)),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(_isPasswordVisible
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            )),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Forgot Password?',
                    style: GoogleFonts.readexPro(
                        color: Colors.blue, fontWeight: FontWeight.w300),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      'Login',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      // do something
                      (() async {
                        await userProvider.login(email, password);
                        final snackBar = SnackBar(
                          backgroundColor: userProvider.isLogin == 1
                              ? Colors.green
                              : Colors.redAccent,
                          content: userProvider.isLogin == 1
                              ? const Text('Dang nhap thanh cong!')
                              :
                          const Text('Thong tin dang nhap khong chinh xac!'),
                          action: SnackBarAction(
                            label: 'Close',
                            onPressed: () {
                              // Some code to undo the change.
                            },
                          ),
                        );
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        if(userProvider.isLogin == 1){
                          // ignore: use_build_context_synchronously
                          Navigator.pushNamedAndRemoveUntil(context, RouteName.home,(route) => false,);
                          final String? currentToken =
                          await FirebaseMessaging.instance
                              .getToken();
                          notificationProvider.getListNotification(userProvider.userCurrent!.id);
                          chatProvider.getRoomChat(userProvider.userCurrent!.id);
                          fcmTokenProvider.checkUserTurnOff(userProvider.userCurrent!.id, currentToken!, true);

                        }
                      })();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget loginGoogle(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Divider(
                  height: 10,
                  thickness: 1,
                  color: Colors.grey.withOpacity(0.4),
                  indent: 5,
                  endIndent: 20,
                ),
              ),
              Text(
                "OR",
                style: GoogleFonts.readexPro(
                    fontSize: 15,
                    fontWeight: FontWeight.w300,
                    color: Colors.black54),
              ),
              Expanded(
                child: Divider(
                  height: 10,
                  thickness: 1,
                  color: Colors.grey.withOpacity(0.4),
                  indent: 20,
                  endIndent: 5,
                ),
              )
            ],
          ),
          const SizedBox(
            height: 25,
          ),
          Consumer4<UserModel,NotificationModel,ChatModel,FcmTokenModel>(
            builder: (context, userProvider,notificationProvider,chatProvider,fcmTokenProvider, child) =>  InkWell(
              onTap: ()  async {
                await AuthService().signInWithGoogle(context);
                notificationProvider.getListNotification(userProvider.userCurrent!.id);
                chatProvider.getRoomChat(userProvider.userCurrent!.id);
                final String? currentToken =
                await FirebaseMessaging.instance
                    .getToken();
                fcmTokenProvider.checkUserTurnOff(userProvider.userCurrent!.id, currentToken!, true);
                },
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 60,
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(15)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image.network(
                      'https://cdn-icons-png.flaticon.com/512/2991/2991148.png',
                      width: 30,
                      height: 30,
                    ),
                    Text(
                      'Login with Google',
                      style: GoogleFonts.readexPro(
                          fontSize: 16, fontWeight: FontWeight.w300),
                    ),
                    const SizedBox(
                      height: 40,
                      width: 20,
                    )
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Don't have an account?",
                style: GoogleFonts.readexPro(
                    fontSize: 15,
                    fontWeight: FontWeight.w300,
                    color: Colors.grey),
              ),
              const SizedBox(
                width: 5,
              ),
              InkWell(
                onTap: () => Navigator.pushNamed(context, RouteName.register),
                child: Text(
                  "Register",
                  style: GoogleFonts.readexPro(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: Colors.blue),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
