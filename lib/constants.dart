// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

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

MaterialColor materialColor(String hexcode) {
  Color color = colorHex(hexcode);
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
  return MaterialColor(hex2int(hexcode), map_color);
}

class CustomButton extends StatelessWidget {
  final Color? accentColor;
  final Color? mainColor;
  final String? text;
  final Function? onpress;

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
      onPressed: () => func!(),
      child: Row(
        children: [
          Icon(icon, size: 18),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              text,
              style: TextStyle(
                fontFamily: 'Times New Roman',
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
  final bool? obscure;
  final TextInputType? keyboard;
  final TextEditingController? controller;
  CustomTextInput(
      {this.hintText,
      this.leading,
      this.controller,
      this.obscure,
      this.keyboard = TextInputType.text});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      padding: EdgeInsets.only(left: 10),
      width: MediaQuery.of(context).size.width * 0.70,
      child: TextField(
        controller: controller,
        keyboardType: keyboard,
        autofocus: false,
        obscureText: obscure!,
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
                      outlinedTextButton(
                          'No', () => Navigator.of(context).pop(false), color1),
                      SizedBox(width: 20),
                      outlinedTextButton(
                          'Yes', () => Navigator.of(context).pop(true), color1),
                    ],
                  )
                ],
              ),
            );
          })) ??
      false;
}

peachyToast(BuildContext context, String text, {int duration = 500}) {
  FToast ftoast = FToast();
  ftoast.init(context);

  ftoast.showToast(
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
