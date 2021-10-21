import 'dart:async';

import 'package:flutter/widgets.dart';

import '../constants.dart';
import './client.dart';
import '../dialogs/server_dialog.dart';

void CONNECT(Client client, Function setState, BuildContext context,
    bool Function() getSentConnect, Function(bool) setSentConnect,
    {bool showToast = false}) async {
  _showToast(String text, {int duration = 350}) =>
      showToast ? peachyToast(context, text, duration: duration) : null;

  if (ServerSettings.loaded) {
    if (!client.alive) {
      if (!getSentConnect()) {
        if (!client.alive) {
          setSentConnect(true);
          print('sentConnect');

          client.connect().then(
            (value) {
              print('sentConnect done');
              setSentConnect(false);

              setState();
              if (value)
                _showToast('Connected to Server!');
              else {
                _showToast('Server Error!\nRetrying in 5 seconds!',
                    duration: 5000);
                Timer(
                    Duration(seconds: 5),
                    () => CONNECT(client, setState, context, getSentConnect,
                        setSentConnect,
                        showToast: showToast));
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
  setState();
}
