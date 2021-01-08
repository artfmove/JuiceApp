import 'package:flutter/material.dart';

class CustomProgressIndicator extends StatefulWidget {
  @override
  _CustomProgressIndicatorState createState() =>
      _CustomProgressIndicatorState();
}

class _CustomProgressIndicatorState extends State<CustomProgressIndicator>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<Offset> _slideAnimation;
  Animation<Offset> _slideAnimation2;
  Animation<Offset> _slideAnimationRight;
  Animation<Offset> _slideAnimationRight2;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 600,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(-1.3, 0),
      end: Offset(0, 0),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.fastOutSlowIn,
      ),
    );
    _slideAnimation2 = Tween<Offset>(
      begin: Offset(-1, 0),
      end: Offset(0, 0),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.fastOutSlowIn,
      ),
    );

    _slideAnimationRight2 = Tween<Offset>(
      begin: Offset(1.3, 0),
      end: Offset(0, 0),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.fastOutSlowIn,
      ),
    );

    _slideAnimationRight = Tween<Offset>(
      begin: Offset(1, 0),
      end: Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    print('dispose');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _controller.repeat(reverse: true);
    //_controller.reverse();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SlideTransition(
          transformHitTests: true,
          position: _slideAnimation,
          child: Image.asset(
            'assets/images/1.png',
            height: 100,
          ),
        ),
        SlideTransition(
          transformHitTests: true,
          position: _slideAnimation2,
          child: Image.asset(
            'assets/images/2.png',
            height: 100,
          ),
        ),
        Image.asset(
          'assets/images/3.png',
          height: 100,
        ),
        SlideTransition(
          transformHitTests: true,
          position: _slideAnimationRight,
          child: Image.asset(
            'assets/images/4.png',
            height: 100,
          ),
        ),
        SlideTransition(
          transformHitTests: true,
          position: _slideAnimationRight2,
          child: Image.asset(
            'assets/images/5.png',
            height: 100,
          ),
        ),
      ],
    );
  }
}
