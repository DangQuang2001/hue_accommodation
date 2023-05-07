import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hue_accommodation/view_models/chat_model.dart';
import 'package:hue_accommodation/view_models/user_model.dart';
import 'package:hue_accommodation/views/login_register/choose_role.dart';
import 'package:provider/provider.dart';

import '../../view_models/notification_model.dart';
import '../components/layout.dart';
import 'login.dart';

class AuthService {
  //Determine if the user is authenticated and redirect accordingly
  handleAuthState() {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            var userProvider = Provider.of<UserModel>(context, listen: true);
            if (userProvider.userCurrent != null && userProvider.isNewAccount) {
              return ChooseRolePage(email: userProvider.userCurrent!.email);
            } else {
              return const Layout(
                selectedIndex: 0,
              );
            }
          } else {
            return const LoginPage();
          }
        });
  }

  Future<UserCredential> signInWithGoogle(BuildContext context) async {
    var userProvider = Provider.of<UserModel>(context, listen: false);

    // Initiate the auth procedure
    final GoogleSignInAccount? googleUser =
        await GoogleSignIn(scopes: <String>["email"]).signIn();
    // fetch the auth details from the request made earlier
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;
    if (userProvider.userCurrent == null) {
      await userProvider.checkIsmailGoogle(
          googleUser.email, googleUser.displayName!, googleUser.photoUrl!);
    }
    // Create a new credential for signing in with google
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<void> signOut(BuildContext context) async {
    final GoogleSignIn googleUser = GoogleSignIn();
    await FirebaseAuth.instance.signOut();
    googleUser.disconnect();
    // ignore: use_build_context_synchronously
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => const Layout(
                  selectedIndex: 0,
                )),
        (route) => false);
  }
}
