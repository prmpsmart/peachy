import 'package:flutter/material.dart';
import 'package:peachy/backend/client.dart';

import '../constants.dart';

class PeachySignUp extends StatefulWidget {
  @override
  _PeachySignUpState createState() => _PeachySignUpState();
}

class _PeachySignUpState extends State<PeachySignUp>
    with SingleTickerProviderStateMixin {
  AnimationController mainController;
  Animation mainAnimation;

  String name;
  String username;
  String password;
  bool signingup = false;

  @override
  void initState() {
    super.initState();
    mainController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    mainAnimation = ColorTween(
      begin: materialColor('#d85461'),
      end: Color(0xFFFEF9EB),
    ).animate(mainController);
    mainController.forward();
    mainController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: Theme.of(context).accentColor,
          height: MediaQuery.of(context).size.height,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                peachyLogo(context),
                CustomTextInput(
                  hintText: 'Name',
                  leading: Icons.text_format,
                  obscure: false,
                  userTyped: (value) {
                    name = value;
                  },
                ),
                SizedBox(
                  height: 0,
                ),
                CustomTextInput(
                  hintText: 'Username',
                  obscure: false,
                  leading: Icons.supervised_user_circle,
                  userTyped: (value) {
                    username = value;
                  },
                ),
                SizedBox(
                  height: 0,
                ),
                SizedBox(
                  height: 0,
                ),
                CustomTextInput(
                  hintText: 'Password',
                  leading: Icons.lock,
                  keyboard: TextInputType.visiblePassword,
                  obscure: true,
                  userTyped: (value) {
                    password = value;
                  },
                ),
                SizedBox(
                  height: 30,
                ),
                Hero(
                  tag: 'signupbutton',
                  child: CustomButton(
                    onpress: () {
                      if (username.isNotEmpty &&
                          password.isNotEmpty &&
                          name.isNotEmpty)
                        Navigator.pushReplacementNamed(context, '/home',
                            arguments:
                                User(username, key: password, name: name));
                    },
                    text: 'signup',
                    accentColor: Colors.white,
                    mainColor: Theme.of(context).primaryColor,
                  ),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    child: Text(
                      'or log in instead',
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          color: Theme.of(context).primaryColor),
                    )),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                ),
                Hero(
                  tag: 'footer',
                  child: Text('♥ Mimi Pesco (Peach)\n      @PRMPSmart'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
