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

    var tag = Tag({
    'NAME': 'ade1',
    'ID': 'ade1',
    'ICON': "",
    'DESCRIPTION': "",
    'EXT': "",
    'users': [
      Tag({
        'NAME': 'ade2',
        'ID': 'ade2',
        'ICON': "",
        'DESCRIPTION': "",
        'EXT': "",
      }),
      Tag({
        'NAME': 'ade3',
        'ID': 'ade3',
        'ICON': "",
        'DESCRIPTION': "",
        'EXT': "",
      }),
      Tag({
        'NAME': 'ade4',
        'ID': 'ade4',
        'ICON': "",
        'DESCRIPTION': "",
        'EXT': "",
      }),
    ],
    'groups': [
      Tag({
        'NAME': 'G_ade1',
        'ID': 'g_ade1',
        'ICON': "",
        'DESCRIPTION': "",
        'EXT': "",
        'CREATOR': 'ade1',
        'admins': [
          'ade1',
        ],
        'users': [
          Tag({
            'NAME': 'ade1',
            'ID': 'ade1',
            'ICON': "",
            'DESCRIPTION': "",
            'EXT': "",
          }),
          Tag({
            'NAME': 'ade2',
            'ID': 'ade2',
            'ICON': "",
            'DESCRIPTION': "",
            'EXT': "",
          }),
          Tag({
            'NAME': 'ade3',
            'ID': 'ade3',
            'ICON': "",
            'DESCRIPTION': "",
            'EXT': "",
          }),
          Tag({
            'NAME': 'ade4',
            'ID': 'ade4',
            'ICON': "",
            'DESCRIPTION': "",
            'EXT': "",
          })
        ],
        'only_admin': false,
      }),
      Tag({
        'NAME': 'G_ade2',
        'ID': 'g_ade2',
        'ICON': "",
        'DESCRIPTION': "",
        'EXT': "",
        'CREATOR': 'ade1',
        'admins': [
          'ade1',
        ],
        'users': [
          Tag({
            'NAME': 'ade1',
            'ID': 'ade1',
            'ICON': "",
            'DESCRIPTION': "",
            'EXT': "",
          }),
          Tag({
            'NAME': 'ade2',
            'ID': 'ade2',
            'ICON': "",
            'DESCRIPTION': "",
            'EXT': "",
          }),
          Tag({
            'NAME': 'ade3',
            'ID': 'ade3',
            'ICON': "",
            'DESCRIPTION': "",
            'EXT': "",
          }),
          Tag({
            'NAME': 'ade4',
            'ID': 'ade4',
            'ICON': "",
            'DESCRIPTION': "",
            'EXT': "",
          })
        ],
        'only_admin': false,
      }),
      Tag({
        'NAME': 'G_ade3',
        'ID': 'g_ade3',
        'ICON': "",
        'DESCRIPTION': "",
        'EXT': "",
        'CREATOR': 'ade1',
        'admins': [
          'ade1',
        ],
        'users': [
          Tag({
            'NAME': 'ade1',
            'ID': 'ade1',
            'ICON': "",
            'DESCRIPTION': "",
            'EXT': "",
          }),
          Tag({
            'NAME': 'ade2',
            'ID': 'ade2',
            'ICON': "",
            'DESCRIPTION': "",
            'EXT': "",
          }),
          Tag({
            'NAME': 'ade3',
            'ID': 'ade3',
            'ICON': "",
            'DESCRIPTION': "",
            'EXT': "",
          }),
          Tag({
            'NAME': 'ade4',
            'ID': 'ade4',
            'ICON': "",
            'DESCRIPTION': "",
            'EXT': "",
          })
        ],
        'only_admin': false,
      }),
      Tag({
        'NAME': 'G_ade4',
        'ID': 'g_ade4',
        'ICON': "",
        'DESCRIPTION': "",
        'EXT': "",
        'CREATOR': 'ade1',
        'admins': [
          'ade1',
        ],
        'users': [
          Tag({
            'NAME': 'ade1',
            'ID': 'ade1',
            'ICON': "",
            'DESCRIPTION': "",
            'EXT': "",
          }),
          Tag({
            'NAME': 'ade2',
            'ID': 'ade2',
            'ICON': "",
            'DESCRIPTION': "",
            'EXT': "",
          }),
          Tag({
            'NAME': 'ade3',
            'ID': 'ade3',
            'ICON': "",
            'DESCRIPTION': "",
            'EXT': "",
          }),
          Tag({
            'NAME': 'ade4',
            'ID': 'ade4',
            'ICON': "",
            'DESCRIPTION': "",
            'EXT': "",
          })
        ],
        'only_admin': false,
      }),
    ],
    'channels': [
      Tag({
        'NAME': 'C_ade1',
        'ID': 'c_ade1',
        'ICON': "",
        'DESCRIPTION': "",
        'EXT': "",
        'CREATOR': 'ade1',
        'admins': [
          'ade1',
        ],
        'users': [
          Tag({
            'NAME': 'ade1',
            'ID': 'ade1',
            'ICON': "",
            'DESCRIPTION': "",
            'EXT': "",
          }),
          Tag({
            'NAME': 'ade2',
            'ID': 'ade2',
            'ICON': "",
            'DESCRIPTION': "",
            'EXT': "",
          }),
          Tag({
            'NAME': 'ade3',
            'ID': 'ade3',
            'ICON': "",
            'DESCRIPTION': "",
            'EXT': "",
          }),
          Tag({
            'NAME': 'ade4',
            'ID': 'ade4',
            'ICON': "",
            'DESCRIPTION': "",
            'EXT': "",
          })
        ],
        'only_admin': true,
      }),
      Tag({
        'NAME': 'C_ade2',
        'ID': 'c_ade2',
        'ICON': "",
        'DESCRIPTION': "",
        'EXT': "",
        'CREATOR': 'ade1',
        'admins': ['ade1', 'ade2'],
        'users': [
          Tag({
            'NAME': 'ade1',
            'ID': 'ade1',
            'ICON': "",
            'DESCRIPTION': "",
            'EXT': "",
          }),
          Tag({
            'NAME': 'ade2',
            'ID': 'ade2',
            'ICON': "",
            'DESCRIPTION': "",
            'EXT': "",
          }),
          Tag({
            'NAME': 'ade3',
            'ID': 'ade3',
            'ICON': "",
            'DESCRIPTION': "",
            'EXT': "",
          }),
          Tag({
            'NAME': 'ade4',
            'ID': 'ade4',
            'ICON': "",
            'DESCRIPTION': "",
            'EXT': "",
          })
        ],
        'only_admin': true,
      }),
      Tag({
        'NAME': 'C_ade3',
        'ID': 'c_ade3',
        'ICON': "",
        'DESCRIPTION': "",
        'EXT': "",
        'CREATOR': 'ade1',
        'admins': [
          'ade1',
        ],
        'users': [
          Tag({
            'NAME': 'ade1',
            'ID': 'ade1',
            'ICON': "",
            'DESCRIPTION': "",
            'EXT': "",
          }),
          Tag({
            'NAME': 'ade2',
            'ID': 'ade2',
            'ICON': "",
            'DESCRIPTION': "",
            'EXT': "",
          }),
          Tag({
            'NAME': 'ade3',
            'ID': 'ade3',
            'ICON': "",
            'DESCRIPTION': "",
            'EXT': "",
          }),
          Tag({
            'NAME': 'ade4',
            'ID': 'ade4',
            'ICON': "",
            'DESCRIPTION': "",
            'EXT': "",
          })
        ],
        'only_admin': true,
      }),
      Tag({
        'NAME': 'C_ade4',
        'ID': 'c_ade4',
        'ICON': "",
        'DESCRIPTION': "",
        'EXT': "",
        'CREATOR': 'ade1',
        'admins': [
          'ade1',
        ],
        'users': [
          Tag({
            'NAME': 'ade1',
            'ID': 'ade1',
            'ICON': "",
            'DESCRIPTION': "",
            'EXT': "",
          }),
          Tag({
            'NAME': 'ade2',
            'ID': 'ade2',
            'ICON': "",
            'DESCRIPTION': "",
            'EXT': "",
          }),
          Tag({
            'NAME': 'ade3',
            'ID': 'ade3',
            'ICON': "",
            'DESCRIPTION': "",
            'EXT': "",
          }),
          Tag({
            'NAME': 'ade4',
            'ID': 'ade4',
            'ICON': "",
            'DESCRIPTION': "",
            'EXT': "",
          })
        ],
        'only_admin': true,
      })
    ]
  });
    user!.load_data(tag);
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
