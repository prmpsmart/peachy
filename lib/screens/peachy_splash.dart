// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import '../constants.dart';
import '../backend/client.dart' as _client;
import 'dart:async';

class PeachySplash extends StatefulWidget {
  _client.User? user;
  PeachySplash(this.user);
  @override
  _PeachySplashState createState() => _PeachySplashState();
}

class _PeachySplashState extends State<PeachySplash> {
  @override
  Widget build(BuildContext context) {
    Timer(
      Duration(seconds: 2),
      () {
        String route = 'createUser';
        if (widget.user != null) route = 'home';

        Navigator.pushReplacementNamed(context, '/$route', arguments: false);
      },
    );

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
          ),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [peachyLogo(context), peachyFooter(context)]),
        ),
      ),
    );
  }
}
