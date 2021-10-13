import 'package:flutter/material.dart';
import '../constants.dart';
import '../backend/client.dart' as _client;
import 'dart:async';

class PeachySplash extends StatefulWidget {
  _client.User user;
  PeachySplash(this.user);
  @override
  _PeachySplashState createState() => _PeachySplashState();
}

class _PeachySplashState extends State<PeachySplash> {
  // @override

  @override
  Widget build(BuildContext context) {
    Timer(Duration(seconds: 2), () {
      String route = 'createUser';
      if (widget.user != null) route = 'home';

      Navigator.pushReplacementNamed(context, '/$route');
    });

    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).accentColor,
        ),
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          peachyLogo(context),
          Hero(
            tag: 'footer',
            child: Text(
              '♥ Mimi Pesco (Peach)\n      @PRMPSmart',
              style: TextStyle(
                decoration: TextDecoration.none,
                color: Theme.of(context).primaryColor,
                fontFamily: 'Poppins',
                fontSize: 15,
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.normal,
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
