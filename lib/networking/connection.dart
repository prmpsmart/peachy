// ignore_for_file: non_constant_identifier_names, must_be_immutable

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:peachy/widgets/toast.dart';

import '../constants.dart';
import '../backend/client.dart';
import '../dialogs/server_dialog.dart';

class ConnectionWidget extends StatefulWidget {
  Client? client;
  bool showPop = false;
  ConnectionWidget(this.showPop, this.client);

  @override
  ConnectionWidgetState createState() => ConnectionWidgetState();
}

class ConnectionWidgetState<C_W extends ConnectionWidget> extends State<C_W> {
  bool sentConnect = false;
  late Timer timer;
  FToast toast = FToast();
  late Widget scaffold;
  bool showToast = false;

  Client? get client => widget.client;
  set client(Client? c) => widget.client = c;
  bool get alive => client?.alive ?? false;
  bool get online => alive;

  statusWatcher(bool value) {
    print('$runtimeType.statusWatcher: $value');
    if (!value)
      connect();
    else
      setState(() {});
  }

  @override
  void initState() {
    toast.init(context);

    ServerSettings.load();

    WidgetsBinding.instance!.addPostFrameCallback(
      (timeStamp) => timer = Timer(Duration(seconds: 2), connect),
    );
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
                        outlinedTextButton('Yes',
                            () => Navigator.of(context).pop(true), color1),
                      ],
                    )
                  ],
                ),
              );
            })) ??
        false;
  }

  void connect() async {
    _showToast(String text, {int duration = 350}) => showToast
        ? peachyToast(context, text, duration: duration, toast: toast)
        : null;

    if (ServerSettings.loaded) {
      if (client == null)
        client = Client(ServerSettings.ip as String, ServerSettings.port as int,
            statusWatcher: statusWatcher);
      else
        client?.statusWatcher = statusWatcher;
      if (!alive) {
        if (!sentConnect) {
          if (!alive) {
            sentConnect = true;
            // print('sentConnect');

            client?.connect().then(
              (value) {
                // print('sentConnect done');
                sentConnect = false;

                setState(() {});
                if (value)
                  _showToast('Connected to Server!');
                else {
                  _showToast('Server Error!\nRetrying in 5 seconds!',
                      duration: 5000);
                  Timer(Duration(seconds: 5), () => connect());
                  return;
                }
              },
            );
          }
          _showToast('Sent Connect!');
        } else
          _showToast('Already Sent Connect!');
      } else
        _showToast('Already Connected!');
    } else
      _showToast('Set the Server details', duration: 1500);
    setState(() {});
  }
}
