import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';
import '../provider/auth.dart';
import '../widgets/auth_methods.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with TickerProviderStateMixin {
  final fieldStyle = TextStyle(fontSize: 15);

  //Animation<Offset> _slideAnimation
  AnimationController _controller;
  AnimationController _controllerMethods;
  Animation<Offset> _slideAnimation;
  Animation<double> _opacityAnimation;
  Animation<double> _opacityAnimationMethods;
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 300,
      ),
    );
    _controllerMethods = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 300,
      ),
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, -1.5),
      end: Offset(0, 0),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.fastOutSlowIn,
      ),
    );
    _opacityAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );
    _opacityAnimationMethods = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controllerMethods,
        curve: Curves.easeIn,
      ),
    );
    // _heightAnimation.addListener(() => setState(() {}));
  }

  bool loginMode = true;
  bool byEmail = false;

  Map<String, String> authData = {
    'email': '',
    'password': '',
    'confirmedPassword': '',
  };

  @override
  dispose() {
    _controller.dispose();
    _controllerMethods.dispose();
    super.dispose();
  }

  void _switchAuthMode() {
    if (loginMode) {
      setState(() {
        loginMode = !loginMode;
      });
      _controller.forward();
    } else {
      setState(() {
        loginMode = !loginMode;
      });
      _controller.reverse();
    }
  }

  void switchAuthMethod() {
    setState(() {
      byEmail = !byEmail;
      _controllerMethods.reset();
      _controllerMethods.forward();
    });
    print('ddd');
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context, listen: false);
    final node = FocusScope.of(context);
    final mediaQuery = MediaQuery.of(context);
    print('authscreeeen');
    final deviceSize = MediaQuery.of(context).size;
    _controllerMethods.forward();
    return PlatformScaffold(
      material: (_, __) =>
          MaterialScaffoldData(resizeToAvoidBottomInset: false),
      appBar: PlatformAppBar(
        title: PlatformText('Authentication'),
      ),
      body: Center(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: FadeTransition(
            opacity: _opacityAnimationMethods,
            child: !byEmail
                ? AuthMethods(_signInButton, switchAuthMethod, context)
                : Stack(
                    alignment: AlignmentDirectional.bottomCenter,
                    fit: StackFit.passthrough,
                    children: [
                      Scaffold(
                        body: ListView(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  './assets/images/juice.png',
                                  width: 200,
                                  fit: BoxFit.cover,
                                ),
                                Padding(padding: EdgeInsets.only(top: 50)),
                                Container(
                                  width: deviceSize.width * 0.7,
                                  child: TextFormField(
                                      onChanged: (value) {
                                        authData['email'] = value;
                                      },
                                      textInputAction: TextInputAction.next,
                                      onEditingComplete: () => node.nextFocus(),
                                      style: fieldStyle,
                                      keyboardType: TextInputType.emailAddress,
                                      decoration:
                                          InputDecoration(labelText: 'Email')),
                                  //controller: textEditingController,
                                ),
                                SizedBox(height: 20),
                                Container(
                                  width: deviceSize.width * 0.7,
                                  child: TextFormField(
                                      style: fieldStyle,
                                      textInputAction: TextInputAction.next,
                                      obscureText: true,
                                      decoration: InputDecoration(
                                          labelText: 'Password'),
                                      onChanged: (value) {
                                        authData['password'] = value;
                                      },
                                      onEditingComplete: () {
                                        if (loginMode) {
                                          auth.authenticate(
                                              loginMode,
                                              authData['email'],
                                              authData['password'],
                                              authData['confirmedPassword'],
                                              context);
                                          node.unfocus();
                                        } else
                                          node.nextFocus();
                                      }),
                                ),
                                SizedBox(height: 20),
                                FadeTransition(
                                  opacity: _opacityAnimation,
                                  child: SlideTransition(
                                    position: _slideAnimation,
                                    child: Container(
                                      width: deviceSize.width * 0.7,
                                      child: TextFormField(
                                        style: fieldStyle,
                                        obscureText: true,
                                        textInputAction: TextInputAction.done,
                                        onEditingComplete: () {
                                          auth.authenticate(
                                              loginMode,
                                              authData['email'],
                                              authData['password'],
                                              authData['confirmedPassword'],
                                              context);
                                          node.unfocus();
                                        },
                                        decoration: InputDecoration(
                                            labelText: 'Repeat password'),
                                        onChanged: (value) {
                                          authData['confirmedPassword'] = value;
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      mediaQuery.viewInsets.bottom != 0
                          ? SizedBox(
                              height: 0,
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: () => switchAuthMethod(),
                                  child:
                                      //  Image.asset(
                                      //   './assets/images/google_logo.png',
                                      //   height: 35.0,
                                      //   width: 35.0,
                                      // ),
                                      Text(
                                    'Choose another authentication option',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                GestureDetector(
                                  onTap: () => setState(() {
                                    _switchAuthMode();
                                  }),
                                  child: Text(
                                    loginMode ? 'or Sign Up' : 'or Log In ',
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ),
                                SizedBox(height: 20),
                                Padding(
                                  padding: EdgeInsets.all(8),
                                  child: PlatformButton(
                                      //color: Theme.of(context).primaryColor,
                                      padding:
                                          EdgeInsets.symmetric(vertical: 20),
                                      onPressed: () {
                                        auth.authenticate(
                                            loginMode,
                                            authData['email'],
                                            authData['password'],
                                            authData['confirmedPassword'],
                                            context);

                                        // if (auth.getMessageError != null)
                                        //   showErrorMessage(auth.getMessageError);
                                        print(authData);
                                      },
                                      child: Text(
                                        loginMode ? 'Login' : 'Sign',
                                        style: TextStyle(fontSize: 30),
                                      )),
                                ),
                              ],
                            )
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

Widget _signInButton() {
  return OutlineButton(
    splashColor: Colors.grey,
    onPressed: () {},
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
    highlightElevation: 0,
    borderSide: BorderSide(color: Colors.grey),
    child: Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image(
              image: AssetImage('./assets/images/google_logo.png'),
              height: 35.0),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              'Sign in with Google',
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey,
              ),
            ),
          )
        ],
      ),
    ),
  );
}
