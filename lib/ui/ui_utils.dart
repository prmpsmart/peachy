// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:peachy/backend/constants.dart';
import 'package:peachy/backend/tag.dart';
import 'package:peachy/backend/user.dart';

import 'widgets/toast.dart';

Map<int, Color> color = {
  50: Color.fromRGBO(136, 14, 79, .1),
  100: Color.fromRGBO(136, 14, 79, .2),
  200: Color.fromRGBO(136, 14, 79, .3),
  300: Color.fromRGBO(136, 14, 79, .4),
  400: Color.fromRGBO(136, 14, 79, .5),
  500: Color.fromRGBO(136, 14, 79, .6),
  600: Color.fromRGBO(136, 14, 79, .7),
  700: Color.fromRGBO(136, 14, 79, .8),
  800: Color.fromRGBO(136, 14, 79, .9),
  900: Color.fromRGBO(136, 14, 79, 1),
};

MaterialColor colorCustom = MaterialColor(0xFF880E4F, color);

int hex2int(String hexcode) {
  String color = '0xFF' + hexcode;
  color = color.replaceAll('#', '');
  return int.parse(color);
}

Color colorHex(String hexcode) {
  int color = hex2int(hexcode);
  return Color(color);
}

MaterialColor materialColor(color_value) {
  Color color = (color_value is String) ? colorHex(color_value) : color_value;
  Map<int, Color> map_color = {
    50: color.withOpacity(.1),
    100: color.withOpacity(.2),
    200: color.withOpacity(.3),
    300: color.withOpacity(.4),
    400: color.withOpacity(.5),
    500: color.withOpacity(.6),
    600: color.withOpacity(.7),
    700: color.withOpacity(.8),
    800: color.withOpacity(.9),
    900: color.withOpacity(1),
  };
  return MaterialColor(color.value, map_color);
}

class CustomButton extends StatelessWidget {
  final Color? accentColor;
  final Color? mainColor;
  final String? text;
  final VoidCallback? onpress;

  CustomButton({this.accentColor, this.text, this.mainColor, this.onpress});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
            color: accentColor!,
          ),
          color: mainColor,
          borderRadius: BorderRadius.circular(20)),
      width: MediaQuery.of(context).size.width * 0.6,
      height: 40,
      child: MaterialButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        splashColor: accentColor,
        onPressed: () => onpress!(),
        child: Center(
          child: Text(
            text!.toUpperCase(),
            style: TextStyle(fontFamily: 'Poppins', color: accentColor),
          ),
        ),
      ),
    );
  }
}

Container iconNButton(String text, IconData icon, {Function? func}) {
  return Container(
    height: 30,
    child: ElevatedButton(
      onPressed: () {
        if (func != null) func();
      },
      child: Row(
        children: [
          Icon(icon, size: 18),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              text,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class CustomTextInput extends StatelessWidget {
  final String? hintText;
  final IconData? leading;
  final bool obscure;
  final int maxLines;
  final TextInputType? keyboard;
  final TextEditingController? controller;
  final double radius;
  CustomTextInput(
      {this.hintText,
      this.leading,
      this.controller,
      this.obscure = false,
      this.maxLines = 1,
      this.radius = 30,
      this.keyboard = TextInputType.text});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
      padding: EdgeInsets.only(left: 10),
      width: MediaQuery.of(context).size.width * 0.70,
      child: TextField(
        controller: controller,
        keyboardType: keyboard,
        autofocus: false,
        obscureText: obscure,
        maxLines: maxLines,
        decoration: InputDecoration(
          icon: Icon(
            leading,
            color: Theme.of(context).primaryColor,
          ),
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: TextStyle(
            fontFamily: 'Poppins',
          ),
        ),
      ),
    );
  }
}

Column peachyLogo(BuildContext context, {double size = 120}) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Hero(
        tag: 'peachyIcon',
        child: Icon(
          Icons.bubble_chart_outlined,
          size: size,
          color: Theme.of(context).primaryColor,
        ),
      ),
      Hero(
          tag: 'peachy_sb',
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          )),
      Hero(
          tag: 'peachyTitle',
          child: Text(
            'Peachy',
            style: TextStyle(
              decoration: TextDecoration.none,
              color: Theme.of(context).primaryColor,
              fontFamily: 'Poppins',
              fontSize: 26,
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.normal,
            ),
          )),
    ],
  );
}

MaterialButton outlinedTextButton(String text, Function func, Color color) =>
    MaterialButton(
      height: 30,
      minWidth: 40,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: color,
        ),
      ),
      textTheme: ButtonTextTheme.normal,
      splashColor: color,
      onPressed: () => func(),
      onLongPress: () => print('cliecked'),
      child: Text(
        text,
        style: TextStyle(
          color: color,
        ),
      ),
    );

peachyToast(BuildContext context, String text,
    {int duration = 500, Toast? toast}) {
  if (toast == null) {
    toast = Toast();
    toast.init(context);
  }
  toast.showToast(
    toastDuration: Duration(milliseconds: duration),
    child: Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).primaryColor),
      child: Text(
        text,
        style: TextStyle(
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
    ),
  );
}

peachyFooter(BuildContext context) => Hero(
      tag: 'footer',
      child: Text(
        '♥ Mimi Pesco (Peach)\n      @PRMPSmart',
        style: TextStyle(
          decoration: TextDecoration.none,
          color: Theme.of(context).primaryColor,
          fontFamily: 'Poppins',
          fontSize: 15,
          fontWeight: FontWeight.w700,
          fontStyle: FontStyle.normal,
        ),
      ),
    );

class P_StatefulWidget extends StatefulWidget {
  const P_StatefulWidget({Key? key}) : super(key: key);

  @override
  P_StatefulWidgetState createState() => P_StatefulWidgetState();
}

class P_StatefulWidgetState<P_S extends P_StatefulWidget> extends State<P_S> {
  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Container();
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
        onPressed: () => function(),
        child: Icon(icon,
            size: 20, color: Theme.of(context).colorScheme.secondary),
      ),
    ),
  );
}

RawMaterialButton switchIconButton(
    IconData icon, Function function, BuildContext context,
    {double wid = 25, double size = 20}) {
  var btn = RawMaterialButton(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.5)),
    constraints: BoxConstraints(minWidth: wid, minHeight: wid),
    child: Icon(
      icon,
      size: size,
      color: Theme.of(context).colorScheme.secondary,
    ),
    fillColor: Theme.of(context).primaryColor,
    onPressed: () => function(),
  );
  return btn;
}

Text getText(String data, {double size = 20}) =>
    Text(data, style: TextStyle(fontSize: size));

Positioned profileImageWidget(
        BuildContext context, double padding, double radius) =>
    Positioned(
        left: padding,
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          foregroundColor: Theme.of(context).colorScheme.secondary,
          radius: radius,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(radius),
            child: Image.asset("assets/ic_male_ph.jpg"),
          ),
        ));

getTextWidget(BuildContext context, TextEditingController cont, bool b,
        FontWeight fw, String text,
        {bool obscureText = false, int maxLines = 1}) =>
    b
        ? Expanded(
            child: TextField(
              controller: cont,
              obscureText: obscureText,
              maxLines: maxLines,
              style: TextStyle(
                fontSize: 15,
                fontWeight: fw,
              ),
            ),
          )
        : Text(
            obscureText ? '*' * text.length : text,
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 15,
              fontWeight: fw,
            ),
          );

Tag getChangeTag(CONSTANT type, String id, Tag data) {
  String id_type = '';

  if (TYPE['USER'] == type)
    id_type = 'user_id';
  else if (TYPE['GROUP'] == type)
    id_type = 'group_id';
  else if (TYPE['CHANNEL'] == type) id_type = 'channel_id';

  return Tag(
      {'action': ACTION['CHANGE'], id_type: id, 'type': type, 'data': data});
}

Tag getChangeMultiTag(CONSTANT action, CONSTANT type, String chat_object_id,
    {String id = '', data}) {
  // if ((id.isEmpty && (data == null)) || (id == user.id))

  var map = {'action': action, 'user_id': id.isNotEmpty ? id : data};

  if (TYPE['GROUP'] == type) {
    map['type'] = TYPE['GROUP'];
    map['group_id'] = chat_object_id;
  } else if (TYPE['CHANNEL'] == type) {
    map['type'] = TYPE['GROUP'];
    map['group_id'] = chat_object_id;
  }

  return Tag(map);
}
