// ignore_for_file: non_constant_identifier_names, must_be_immutable

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:peachy/backend/user.dart';

import 'ui_utils.dart';
import 'package:peachy/backend/client.dart';
import 'widgets/toast.dart';

class ConnectionWidget extends P_StatefulWidget {
  Client? _client;
  bool showPop;

  User? get user => _client?.user;

  ConnectionWidget(this._client, {this.showPop = false}) {
    ServerSettings.load();
  }

  Client get client {
    if (Client.activeClient == null) Client(user: user);

    return Client.activeClient as Client;
  }

  @override
  ConnectionWidgetState createState() => ConnectionWidgetState();
}

class ConnectionWidgetState<C_W extends ConnectionWidget>
    extends P_StatefulWidgetState<C_W> {
  bool sentConnect = false;
  late Timer timer;
  Toast toast = Toast();
  late Widget scaffold;
  bool showToast = true;

  Client get client => widget.client;
  bool get alive => client.alive;
  bool get online => client.online;

  @override
  void initState() {
    toast.init(context);

    WidgetsBinding.instance!.addPostFrameCallback(
      (timeStamp) => timer = Timer(Duration(seconds: 2), () {
        if (!alive) connect();
      }),
    );
    client.statusWatcher = statusWatcher;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.showPop
        ? scaffold
        : WillPopScope(onWillPop: () => onWillPop(context), child: scaffold);
  }

  @override
  void dispose() {
    timer.cancel();
    try {
      toast.removeCustomToast();
      toast.removeQueuedCustomToasts();
    } catch (e) {}

    super.dispose();
  }

  Future<bool> onWillPop(BuildContext context) async {
    return (await showDialog(
            context: context,
            builder: (context) {
              Color color1 = Theme.of(context).primaryColor;
              Color color2 = Theme.of(context).colorScheme.secondary;

              return Dialog(
                elevation: 5,
                insetPadding: EdgeInsets.symmetric(horizontal: 100),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(
                    color: color1,
                  ),
                ),
                backgroundColor: color2.withOpacity(.8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Exit Peachy?',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                          color: color1,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        outlinedTextButton('No',
                            () => Navigator.of(context).pop(false), color1),
                        SizedBox(width: 20),
                        outlinedTextButton('Yes', () {
                          client.logout();
                          client.stop();
                          Navigator.of(context).pop(true);
                        }, color1),
                      ],
                    )
                  ],
                ),
              );
            })) ??
        false;
  }

  statusWatcher(bool value) {
    if (!value) connect();
    setState(() {});
  }

  void connect() async {
    _showToast(String text, {int duration = 3000}) {
      if (showToast && mounted)
        peachyToast(context, text, duration: duration, toast: toast);
    }

    if (sentConnect) {
      _showToast('Already Sent Connect!');
      return;
    } else if (alive) {
      _showToast('Already Connected!');
      return;
    }

    if (ServerSettings.LOADED) {
      sentConnect = true;
      bool connected = await client.connect();

      if (connected)
        _showToast('Connected to Server!');
      else
        _showToast('Server Error!\nRetrying in 5 seconds!', duration: 5000);

      sentConnect = false;
    } else {
      _showToast('Set the Server details', duration: 1500);
      Timer(Duration(milliseconds: 1500), () async {
        await ServerSettings.load();
        connect();
      });
    }
    setState(() {});
  }
}
