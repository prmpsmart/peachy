import 'package:flutter/material.dart';
import 'package:peachy/constants.dart' as data;
import 'package:peachy/widgets/extras.dart';

class ProfileDialog extends StatefulWidget {
  final data.User user;

  ProfileDialog(this.user);

  @override
  _ProfileDialogState createState() => _ProfileDialogState();
}

class _ProfileDialogState extends State<ProfileDialog> {
  @override
  build(BuildContext context) {
    double padding = 10;
    double radius = 45;
    double iconSize = 23;

    String type;
    switch (widget.user.type) {
      case 1:
        {
          type = 'Contact';
          break;
        }
      case 2:
        {
          type = 'Group';
          break;
        }
      case 1:
        {
          type = 'Channel';
          break;
        }
    }

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(padding),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.only(
                left: padding,
                top: padding + radius,
                bottom: padding,
                right: padding),
            margin: EdgeInsets.only(top: radius),
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Theme.of(context).accentColor,
              borderRadius: BorderRadius.circular(padding),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Apata Miracle Peter',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 22,
                    fontFamily: 'Times New Roman',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      padding: EdgeInsets.only(right: 10),
                      child: ElevatedButton(
                        onPressed: null,
                        child: Text(
                          'ID :',
                          style: TextStyle(
                            fontFamily: 'Times New Roman',
                            // backgroundColor: Theme.of(context).primaryColor,
                            color: Theme.of(context).primaryColor,
                            // color: Theme.of(context).accentColor,
                            // fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    Text(
                      'prmpsmart',
                      style: TextStyle(
                        fontFamily: 'Times New Roman',
                        color: Theme.of(context).primaryColor,
                        // backgroundColor: Colors.yellow,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Divider(height: 5),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Tooltip(
                        message: 'Chat',
                        child: TextButton(
                          child: Icon(
                            Icons.chat_outlined,
                            size: iconSize,
                          ),
                          onPressed: () => print('Chat'),
                        ),
                      ),
                      Tooltip(
                        message: 'Video Call',
                        child: TextButton(
                          child: Icon(
                            Icons.video_call_outlined,
                            size: iconSize + 10,
                          ),
                          onPressed: () => print('Video call'),
                        ),
                      ),
                      Tooltip(
                        message: 'Voice Call',
                        child: TextButton(
                          child: Icon(
                            Icons.call,
                            size: iconSize - 2,
                          ),
                          onPressed: () => print('Voice call'),
                        ),
                      ),
                      Tooltip(
                        message: 'Info',
                        child: TextButton(
                          child: Icon(
                            Icons.info_outline_rounded,
                            size: iconSize + 3,
                          ),
                          onPressed: () => print('Info'),
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(height: 5),
                SizedBox(height: 5),
                iconNButton('Block', Icons.block),
                SizedBox(height: 5),
                iconNButton('Report $type', Icons.thumb_down_sharp),
              ],
            ),
          ),
          Positioned(
              left: padding,
              right: padding,
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                foregroundColor: Theme.of(context).accentColor,
                radius: radius,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(radius),
                  child: Image.asset("assets/ic_male_ph.jpg"),
                ),
              ))
        ],
      ),
    );
  }
}

SizedBox iconButton(IconData icon, Function function, BuildContext context) {
  return SizedBox(
    height: 35,
    width: 35,
    child: Material(
      clipBehavior: Clip.antiAlias,
      borderRadius: BorderRadius.circular(17.5),
      color: Theme.of(context).primaryColor,
      child: ElevatedButton(
        onPressed: function,
        // splashColor: Theme.of(context).accentColor.withOpacity(.5),
        child: Icon(icon, size: 20, color: Theme.of(context).accentColor),
      ),
    ),
  );
}

class PersonalProfileDialog extends StatefulWidget {
  final data.User user;

  PersonalProfileDialog(this.user);

  @override
  _PersonalProfileDialogState createState() => _PersonalProfileDialogState();
}

class _PersonalProfileDialogState extends State<PersonalProfileDialog> {
  @override
  build(BuildContext context) {
    double padding = 10;
    double radius = 45;

    return Dialog(
      shape: RoundedRectangleBorder(
          // borderRadius: BorderRadius.circular(padding),
          ),
      elevation: 1,
      backgroundColor: Colors.transparent,
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.only(
                left: padding,
                top: padding + radius,
                bottom: padding,
                right: padding),
            margin: EdgeInsets.only(top: radius),
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Theme.of(context).accentColor,
              borderRadius: BorderRadius.circular(padding),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(
                      'Username: ',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 13,
                        fontFamily: 'Times New Roman',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Apata Miracle Peter',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 13,
                        fontFamily: 'Times New Roman',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // ElevatedButton(onPressed: null, child: Icon(Icons.edit))
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      padding: EdgeInsets.only(right: 10),
                      child: ElevatedButton(
                        onPressed: null,
                        child: Text(
                          'ID :',
                          style: TextStyle(
                            fontFamily: 'Times New Roman',
                            // backgroundColor: Theme.of(context).primaryColor,
                            color: Theme.of(context).primaryColor,
                            // color: Theme.of(context).accentColor,
                            // fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    Text(
                      'prmpsmart',
                      style: TextStyle(
                        fontFamily: 'Times New Roman',
                        color: Theme.of(context).primaryColor,
                        // backgroundColor: Colors.yellow,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Divider(height: 5),
                SizedBox(height: 5),
                iconNButton('Settings', Icons.settings),
              ],
            ),
          ),
          Positioned(
              left: padding,
              right: padding,
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                foregroundColor: Theme.of(context).accentColor,
                radius: radius,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(radius),
                  child: Image.asset("assets/ic_male_ph.jpg"),
                ),
              ))
        ],
      ),
    );
  }
}
