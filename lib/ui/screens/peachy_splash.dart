// ignore_for_file: must_be_immutable

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:peachy/backend/client.dart';
import 'package:peachy/backend/user_db.dart';
import 'package:peachy/backend/user.dart';
import '../ui_utils.dart';

class PeachySplash extends P_StatefulWidget {
  @override
  _PeachySplashState createState() => _PeachySplashState();
}

class _PeachySplashState extends P_StatefulWidgetState<PeachySplash> {
  User? get user => User_DB.USER;

  @override
  Widget build(BuildContext context) {
    Timer(
      Duration(seconds: 2),
      () {
        String route = 'createUser';
        dynamic args = false;

        if (user != null) {
          route = 'home';
          args = Client(user: user);
        }

        Navigator.pushReplacementNamed(context, '/$route', arguments: args);
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
