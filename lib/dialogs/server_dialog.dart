import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../backend/client.dart';
import '../constants.dart';

class ServerSettings {
  static String? ip;
  static int? port;
  static bool loaded = false;

  static Future<File?> getPath() async {
    var filesDir = await getExternalStorageDirectory();
    File file;

    if (filesDir != null) {
      file = File(filesDir.path + '/server.txt');
      file.create();
      return file;
    }
  }

  static get details => 'ServerSettings(ip=$ip, port=$port, loaded=$loaded)';

  static load() async {
    File? file = await getPath();
    if (file != null) {
      file.openRead();
      file.readAsString().then((read) {
        if (read.isNotEmpty && read.contains(';')) {
          List<String> reads = read.split(';');
          ip = reads[0];
          port = int.parse(reads[1]);
          loaded = true;
        }
      });
    }
  }

  static save() async {
    File? file = await getPath();
    if (file != null) {
      file.openWrite();
      file.writeAsString('$ip;$port');
    }
  }
}

class ServerDialog extends StatefulWidget {
  @override
  _ServerDialogState createState() => _ServerDialogState();
}

class _ServerDialogState extends State<ServerDialog> {
  TextEditingController? ipCont;
  TextEditingController? portCont;

  @override
  void initState() {
    ipCont = TextEditingController(text: ServerSettings.ip ?? '');
    String port = '';
    if (ServerSettings.port != null) port = '${ServerSettings.port}';
    portCont = TextEditingController(text: port);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 50),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: ipCont,
              keyboardType: TextInputType.url,
              decoration: InputDecoration(
                icon: Icon(
                  Icons.add_link,
                  color: Theme.of(context).primaryColor,
                ),
                border: InputBorder.none,
                hintText: 'Server Address',
              ),
            ),
            TextField(
              controller: portCont,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                icon: Icon(
                  Icons.add_link,
                  color: Theme.of(context).primaryColor,
                ),
                border: InputBorder.none,
                hintText: 'Server Port',
              ),
            ),
            iconNButton(
              'Save',
              Icons.save,
              func: () {
                String ip = ipCont!.text;
                String port = portCont!.text;

                if (ip.isNotEmpty && port.isNotEmpty) {
                  ServerSettings.ip = ip;
                  ServerSettings.port = int.parse(port);

                  if (Client.activeClient != null) {
                    Client.activeClient?.ip = ServerSettings.ip as String;
                    Client.activeClient?.port = ServerSettings.port as int;
                  }

                  ServerSettings.save();
                  Navigator.pop(context);
                } else
                  peachyToast(context,
                      'Enter valid details.\ne.g\n(192.168.135.41;7625)');
              },
            )
          ],
        ),
      ),
    );
  }
}
