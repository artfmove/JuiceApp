import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/auth.dart';

class SingleAuthMethod extends StatefulWidget {
  final String imagePath;
  final String text;
  final Function function;
  final BuildContext context2;
  final String method;

  SingleAuthMethod(
      this.imagePath, this.text, this.function, this.context2, this.method);

  @override
  _SingleAuthMethodState createState() => _SingleAuthMethodState();
}

void signIn(String method, Auth auth, BuildContext context2) {
  switch (method) {
    case 'google':
      auth.signInWithGoogle(context2);
  }
}

class _SingleAuthMethodState extends State<SingleAuthMethod> {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context, listen: false);

    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        OutlineButton(
          padding: EdgeInsets.all(0),
          splashColor: Colors.grey,
          onPressed: () => widget.function == null
              ? signIn(widget.method, auth, widget.context2)
              : widget.function(),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
          highlightElevation: 0,
          borderSide: BorderSide(color: Colors.grey),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 10,
                ),
                Image(image: AssetImage(widget.imagePath), height: 35.0),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    widget.text,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
