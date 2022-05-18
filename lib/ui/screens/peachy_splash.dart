// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import '../ui_utils.dart';
import 'package:peachy/backend/user.dart';
import 'package:peachy/backend/tag.dart';
import 'dart:async';

class PeachySplash extends P_StatefulWidget {
  User? user;
  PeachySplash();
  @override
  _PeachySplashState createState() => _PeachySplashState();
}

class _PeachySplashState extends P_StatefulWidgetState<PeachySplash> {
  User? get user => widget.user;
  set user(User? u) => widget.user = u;

  @override
  void initState() {
    var tag = Tag({
      "ID": "ade3",
      "ACTION": "DATA",
      "TYPE": "CONTACT",
      "DATE_TIME": 1650648934067,
      "response": "SUCCESSFUL",
      "action": "DATA",
      "data": {
        "NAME": "ade3",
        "ID": "ade3",
        "ICON": "",
        "BIO": "",
        "DATE_TIME": 1650648934067,
        "STATUS": "OFFLINE",
        "users": [
          {
            "NAME": "ade1",
            "ID": "ade1",
            "ICON": "",
            "BIO": "",
            "DATE_TIME": 1650648934067,
            "STATUS": "OFFLINE"
          },
          {
            "NAME": "ade2",
            "ID": "ade2",
            "ICON": "",
            "BIO": "",
            "DATE_TIME": 1650648934067,
            "STATUS": "OFFLINE"
          },
          {
            "NAME": "ade4",
            "ID": "ade4",
            "ICON": "",
            "BIO": "",
            "DATE_TIME": 1650648934067,
            "STATUS": "OFFLINE"
          }
        ],
        "groups": [
          {
            "NAME": "G_ade1",
            "ID": "g_ade1",
            "ICON": "",
            "BIO": "",
            "CREATOR": "ade1",
            "admins": ["ade1"],
            "users": ["ade1", "ade2", "ade3", "ade4"],
            "only_admin": false,
            "DATE_TIME": 1650648934067
          },
          {
            "NAME": "G_ade2",
            "ID": "g_ade2",
            "ICON": "",
            "BIO": "",
            "CREATOR": "ade1",
            "admins": ["ade1"],
            "users": ["ade1", "ade2", "ade3", "ade4"],
            "only_admin": false,
            "DATE_TIME": 1650648934067
          },
          {
            "NAME": "G_ade3",
            "ID": "g_ade3",
            "ICON": "",
            "BIO": "",
            "CREATOR": "ade1",
            "admins": ["ade1"],
            "users": ["ade1", "ade2", "ade3", "ade4"],
            "only_admin": false,
            "DATE_TIME": 1650648934067
          },
          {
            "NAME": "G_ade4",
            "ID": "g_ade4",
            "ICON": "",
            "BIO": "",
            "CREATOR": "ade1",
            "admins": ["ade1"],
            "users": ["ade1", "ade2", "ade3", "ade4"],
            "only_admin": false,
            "DATE_TIME": 1650648934067
          }
        ],
        "channels": [
          {
            "NAME": "C_ade1",
            "ID": "c_ade1",
            "ICON": "",
            "BIO": "",
            "CREATOR": "ade1",
            "admins": ["ade1"],
            "users": ["ade1", "ade2", "ade3", "ade4"],
            "only_admin": true,
            "DATE_TIME": 1650648934067
          },
          {
            "NAME": "C_ade2",
            "ID": "c_ade2",
            "ICON": "",
            "BIO": "",
            "CREATOR": "ade1",
            "admins": ["ade1", "ade2"],
            "users": ["ade1", "ade2", "ade3", "ade4"],
            "only_admin": true,
            "DATE_TIME": 1650648934067
          },
          {
            "NAME": "C_ade3",
            "ID": "c_ade3",
            "ICON": "",
            "BIO": "",
            "CREATOR": "ade1",
            "admins": ["ade1"],
            "users": ["ade1", "ade2", "ade3", "ade4"],
            "only_admin": true,
            "DATE_TIME": 1650648934067
          },
          {
            "NAME": "C_ade4",
            "ID": "c_ade4",
            "ICON": "",
            "BIO": "",
            "CREATOR": "ade1",
            "admins": ["ade1"],
            "users": ["ade1", "ade2", "ade3", "ade4"],
            "only_admin": true,
            "DATE_TIME": 1650648934067
          }
        ]
      }
    });
    // user = User('ade3', name: 'ade3', key: 'ade3');
    // user?.load_data(tag);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Timer(
      Duration(seconds: 2),
      () {
        String route = 'createUser';
        dynamic args = false;

        if (user != null) {
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
