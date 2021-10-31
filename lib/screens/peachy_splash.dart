// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:peachy/backend/core.dart';
import '../constants.dart';
import '../backend/client.dart' as _client;
import 'dart:async';

class PeachySplash extends StatefulWidget {
  _client.User? user;
  PeachySplash();
  @override
  _PeachySplashState createState() => _PeachySplashState();
}

class _PeachySplashState extends State<PeachySplash> {
  _client.User? get user => widget.user;
  set user(_client.User? u) => widget.user = u;

  @override
  void initState() {
    user = _client.User('ade1', name: 'ade1');

    var data = {
      "NAME": "ade1",
      "USERS": {
        "ade2": {"name": "ade2", "icon": null},
        "ade3": {"name": "ade3", "icon": null},
        "ade4": {"name": "ade4", "icon": null}
      },
      "GROUPS": {
        "g_ade1": {
          "name": "G_ade1",
          "icon": "",
          "creator": "ade1",
          "admins": ["ade1"],
          "users": ["ade1", "ade2", "ade3", "ade4"],
          "only_admin": false
        },
        "g_ade2": {
          "name": "G_ade2",
          "icon": "",
          "creator": "ade1",
          "admins": ["ade1"],
          "users": ["ade1", "ade2", "ade3", "ade4"],
          "only_admin": false
        },
        "g_ade3": {
          "name": "G_ade3",
          "icon": "",
          "creator": "ade1",
          "admins": ["ade1"],
          "users": ["ade1", "ade2", "ade3", "ade4"],
          "only_admin": false
        },
        "g_ade4": {
          "name": "G_ade4",
          "icon": "",
          "creator": "ade1",
          "admins": ["ade1"],
          "users": ["ade1", "ade2", "ade3", "ade4"],
          "only_admin": false
        }
      },
      "CHANNELS": {
        "c_ade1": {
          "name": "C_ade1",
          "icon": "",
          "creator": "ade1",
          "admins": ["ade1"],
          "users": ["ade1", "ade2", "ade3", "ade4"]
        },
        "c_ade2": {
          "name": "C_ade2",
          "icon": "",
          "creator": "ade1",
          "admins": ["ade1", "ade2"],
          "users": ["ade1", "ade2", "ade3", "ade4"]
        },
        "c_ade3": {
          "name": "C_ade3",
          "icon": "",
          "creator": "ade1",
          "admins": ["ade1"],
          "users": ["ade1", "ade2", "ade3", "ade4"]
        },
        "c_ade4": {
          "name": "C_ade4",
          "icon": "",
          "creator": "ade1",
          "admins": ["ade1"],
          "users": ["ade1", "ade2", "ade3", "ade4"]
        }
      },
      "ID": "ade1",
      "ICON": null,
      "EXT": "",
      "RESPONSE": "SUCCESSFUL",
      "ACTION": "DATA"
    };
    var tag = Tag(data);
    user?.load_data(tag);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Timer(
      Duration(seconds: 2),
      () {
        String route = 'createUser';
        dynamic args = false;

        if (widget.user != null) {
          route = 'home';
          args = [user, null];
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
