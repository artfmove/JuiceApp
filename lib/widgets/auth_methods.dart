import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'single_auth_method.dart';

class AuthMethods extends StatelessWidget {
  final Function signInButton;
  final Function switchAuthMethod;
  final BuildContext context2;

  AuthMethods(this.signInButton, this.switchAuthMethod, this.context2);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Choose authentication mode',
            style: TextStyle(fontSize: 20),
          ),
          Container(
            padding: EdgeInsets.all(10),
            width: 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SingleAuthMethod('./assets/images/mail.png', 'by E-mail',
                    switchAuthMethod, context2, 'email'),
                SingleAuthMethod('./assets/images/google_logo.png',
                    'by Google account', null, context2, 'google'),
                SingleAuthMethod('./assets/images/facebook.png', 'by Facebook',
                    null, context2, 'facebook'),
                SingleAuthMethod('./assets/images/twitter.png', 'by Twitter',
                    null, context2, 'twitter'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
