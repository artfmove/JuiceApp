import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';

import 'package:google_sign_in/google_sign_in.dart';
import '../models/http_exception.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:connectivity/connectivity.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
// class User {
//   final String name;
//   final String urlPhoto;
//   User(this.name, this.urlPhoto);
// }

class Auth with ChangeNotifier {
  final auth = FirebaseAuth.instance;
  User user = FirebaseAuth.instance.currentUser;

  final GoogleSignIn googleSignIn = GoogleSignIn();
  String errorMessage;
  String get getMessageError {
    return errorMessage;
  }

  Future<void> checkConnection(BuildContext context) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      dialogNoConnection(context);
    }
  }

  void dialogNoConnection(BuildContext context) {
    showPlatformDialog(
        barrierDismissible: false,
        context: context,
        builder: (ctx) => PlatformAlertDialog(
              title: Text('No internet connection'),
              actions: [
                PlatformButton(
                  child: Text('Check again'),
                  onPressed: () {
                    checkConnection(context);
                    Navigator.of(ctx).pop();
                  },
                ),
                PlatformButton(child: Text('Go to settings'), onPressed: () {})
              ],
            ));
  }

  Future<String> signInWithGoogle(BuildContext context) async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final UserCredential authResult =
        await auth.signInWithCredential(credential).then((_) {
      notifyListeners();
      Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
    });
    final User user = authResult.user;

    if (user != null) {
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final User currentUser = auth.currentUser;
      assert(user.uid == currentUser.uid);

      print('signInWithGoogle succeeded: $user');
      this.user = user;
      notifyListeners();
      return '$user';
    }

    return null;
  }

  String getUser() {
    user = FirebaseAuth.instance.currentUser;
    return user.displayName != null ? user.displayName : 'None';
  }

  Future<void> signOutGoogle() async {
    await googleSignIn.signOut();

    print("User Signed Out");
  }

  bool isAuth() {
    print('aaaaaaaa');
    user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      print('true');
      return true;
    } else {
      print('false');
      return false;
    }
  }

  void signOut() async {
    await auth.signOut();

    //notifyListeners();
  }

  Future<void> authenticate(bool isLogin, String email, String password,
      String confirmedPassword, BuildContext context) async {
    //if (!email.contains('@')) errorMessage = 'Your email is invalid';

    if (!isLogin && password != confirmedPassword)
      errorMessage = 'Passwords are different';

    if (!isLogin && password.length < 3) errorMessage = 'Passwords are short';

    try {
      if (isLogin) {
        await auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        //.catchError((onError) => errorMessage = onError.message());
      } else {
        await auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        //.catchError((onError) => errorMessage = onError.message());
        FirebaseDatabase.instance
            .reference()
            .child('users')
            .child(auth.currentUser.uid)
            .set({
          'id': auth.currentUser.uid,
        }).then((value) => null);
        //.catchError((onError) => errorMessage = onError.message());
      }
      // } on HttpException catch (error) {
      //   if (error.toString().contains('EMAIL_EXISTS')) {
      //     errorMessage = 'This email address is already in use.';
      //   } else if (error.toString().contains('INVALID_EMAIL')) {
      //     errorMessage = 'This is not a valid email address';
      //   } else if (error.toString().contains('WEAK_PASSWORD')) {
      //     errorMessage = 'This password is too weak.';
      //   } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
      //     errorMessage = 'Could not find a user with that email.';
      //   } else if (error.toString().contains('INVALID_PASSWORD')) {
      //     errorMessage = 'Invalid password.';
      //   }
    } on FirebaseAuthException catch (e) {
      errorMessage = e.message;
    }
    // } catch (error) {
    //   // errorMessage = '${error.toString()}33333';

    // } finally {
    //errorMessage = null;

    if (errorMessage != null)
      showPlatformDialog(
          context: context,
          builder: (ctx) => PlatformAlertDialog(
                title: Text('Authentication error...'),
                content: Text(errorMessage),
                actions: [
                  PlatformButton(
                      child: Text('Try again...'),
                      onPressed: () {
                        Navigator.of(context).pop();
                        errorMessage = null;
                      }),
                ],
              ));
    else {
      Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
      errorMessage = null;
    }
    //notifyListeners();
  }
}
