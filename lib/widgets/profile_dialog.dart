import 'package:flutter/material.dart';
import 'package:peachy/widgets/data.dart';

class ProfileDialog extends StatefulWidget {
  final User user;

  const ProfileDialog(this.user);

  @override
  _ProfileDialogState createState() => _ProfileDialogState();
}

class _ProfileDialogState extends State<ProfileDialog> {
  @override
  build(BuildContext context) {
    double padding = 20;
    double radius = 45;
    return Dialog(
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(padding)),
      elevation: 5,
      backgroundColor: Colors.red,
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
              color: Colors.white,
              borderRadius: BorderRadius.circular(padding),
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  offset: Offset(0, 10),
                  blurRadius: 10,
                )
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.user.name,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  height: 22,
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      widget.user.name,
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                )
              ],
            ),
          ),
          Positioned(
              left: padding,
              right: padding,
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: radius,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(radius),
                  child: Image.asset("assets/ic_male_ph.png"),
                ),
              ))
        ],
      ),
    );
  }
}
