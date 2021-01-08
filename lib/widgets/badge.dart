import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class Badge extends StatefulWidget {
  const Badge({
    Key key,
    @required this.child,
    @required this.value,
    this.color,
  }) : super(key: key);

  final Widget child;
  final String value;
  final Color color;

  @override
  _BadgeState createState() => _BadgeState();
}

class _BadgeState extends State<Badge> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
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
  }

  @override
  void dispose() {
    _controller.dispose();
    print('dispose');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('build');
    _controller.reset();
    _controller.forward();
    return Stack(
      overflow: Overflow.visible,
      alignment: Alignment.center,
      children: [
        widget.child,
        widget.value == '0'
            ? Text('')
            : Positioned(
                right: -9,
                top: -9,
                child: SlideTransition(
                  transformHitTests: true,
                  position: _slideAnimation,
                  child: Container(
                    padding: EdgeInsets.all(2.0),
                    // color: Theme.of(context).accentColor,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                      color: widget.color != null ? widget.color : Colors.red,
                    ),
                    constraints: BoxConstraints(
                      minWidth: 23,
                      minHeight: 23,
                    ),
                    child: Center(
                      child: PlatformText(
                        widget.value,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
      ],
    );
  }
}
