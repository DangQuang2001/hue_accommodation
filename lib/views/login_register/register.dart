import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hue_accommodation/constants/route_name.dart';
import 'package:hue_accommodation/view_models/user_view_model.dart';
import 'package:provider/provider.dart';

import '../components/slide_route.dart';
import 'auth_service.dart';
import 'choose_role.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _isPasswordVisible = false;

  late String name;
  late String email;
  late String password;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
            Center(
                child: Image.asset(
              'assets/images/registerImage.png',
              width: 240,
              height: 200,
              fit: BoxFit.cover,
            )),
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
              'Register',
              style: GoogleFonts.readexPro(
                  fontSize: 30, fontWeight: FontWeight.w500),
            ),
          )
        ],
      ),
    );
  }

  Widget login(BuildContext context) {
    return Consumer<UserViewModel>(
      builder: (context, userProvider, child) => Form(
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
                    const Icon(
                      Icons.person_outline_outlined,
                      size: 30,
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

                          if (value.length < 2 || value.length > 50) {
                            return 'Name is so long or so short!';
                          }
                          name = value;
                          return null;
                        },
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey.withOpacity(0.5)),
                          ),
                          hintText: 'Name',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
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
                height: 30,
              ),
              SizedBox(
                height: 50,
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
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                height: 50,
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
                          if (value != password) {
                            return 'Mat khau nhap lai khong dung!';
                          }

                          return null;
                        },
                        obscureText: !_isPasswordVisible,
                        decoration: InputDecoration(
                            hintText: 'Confirm your password',
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
                      'Register',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      // do something
                      (() async {
                        if (await userProvider.checkIsmail(email)) {
                          await userProvider.createUser(
                              name,
                              email,
                              password,
                              "https://www.seekpng.com/png/detail/966-9665317_placeholder-image-person-jpg.png",
                              "",
                              false,
                              false);
                          final snackBar = SnackBar(
                            backgroundColor: Colors.green,
                            content: const Text('Dang ky thanh cong!'),
                            action: SnackBarAction(
                              label: 'Close',
                              onPressed: () {
                                // Some code to undo the change.
                              },
                            ),
                          );

                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          // ignore: use_build_context_synchronously
                          Navigator.of(context).push(slideBottomToTop( ChooseRolePage(email: email,)));
                        } else {
                          final snackBar = SnackBar(
                            backgroundColor: Colors.redAccent,
                            content: const Text('Email da ton tai!'),
                            action: SnackBarAction(
                              label: 'Close',
                              onPressed: () {
                                // Some code to undo the change.
                              },
                            ),
                          );

                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
    return Consumer<UserViewModel>(
      builder: (context, userProvider, child) =>  Padding(
        padding:
            const EdgeInsets.only(top: 10, bottom: 10, left: 30.0, right: 30),
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
              height: 10,
            ),
            InkWell(
              onTap: ()async{
                await AuthService().signInWithGoogle(context);
                if(userProvider.userCurrent!=null && userProvider.isNewAccount == false){
                  // ignore: use_build_context_synchronously
                  Navigator.pushNamedAndRemoveUntil(context, RouteName.home, (route) => false);
                }
                if(userProvider.userCurrent!=null && userProvider.isNewAccount == true){
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).push(slideBottomToTop(ChooseRolePage(email: userProvider.userCurrent!.email)));
                }
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
                    CachedNetworkImage(
                      imageUrl:
                      'https://cdn-icons-png.flaticon.com/512/2991/2991148.png',
                      width: 30,
                      height: 30,
                    ),
                    Text(
                      'Register with Google',
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
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already have an account?",
                  style: GoogleFonts.readexPro(
                      fontSize: 15,
                      fontWeight: FontWeight.w300,
                      color: Colors.grey),
                ),
                const SizedBox(
                  width: 5,
                ),
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Text(
                    "Login",
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
      ),
    );
  }
}
