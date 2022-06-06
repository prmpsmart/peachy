import 'package:flutter/material.dart';
import 'package:peachy/backend/client.dart';
import '../ui_utils.dart';

class ServerDialog extends P_StatefulWidget {
  @override
  _ServerDialogState createState() => _ServerDialogState();
}

class _ServerDialogState extends P_StatefulWidgetState<ServerDialog> {
  TextEditingController? ipCont;
  TextEditingController? portCont;

  @override
  void initState() {
    ipCont = TextEditingController(text: ServerSettings.IP);
    String port = '';
    port = '${ServerSettings.PORT}';
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
                  ServerSettings.IP = ip;
                  ServerSettings.PORT = int.parse(port);
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
