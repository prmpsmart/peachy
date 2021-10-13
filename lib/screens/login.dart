import 'package:flutter/material.dart';

import '../constants.dart';

class PeachyLogin extends StatefulWidget {
  @override
  _PeachyLoginState createState() => _PeachyLoginState();
}

class _PeachyLoginState extends State<PeachyLogin>
    with SingleTickerProviderStateMixin {
  AnimationController mainController;
  Animation mainAnimation;
  String email;
  String password;
  bool loggingin = false;

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
      backgroundColor: Theme.of(context).accentColor,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          // margin: EdgeInsets.only(top:MediaQuery.of(context).size.height*0.2),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                peachyLogo(context),
                // Text(
                //   "World's most private chatting app".toUpperCase(),
                //   style: TextStyle(
                //       fontFamily: 'Poppins',
                //       fontSize: 12,
                //       color: Colors.deepPurple),
                // ),
                CustomTextInput(
                  hintText: 'Username',
                  leading: Icons.person,
                  obscure: false,
                  keyboard: TextInputType.emailAddress,
                  userTyped: (val) {
                    email = val;
                  },
                ),
                SizedBox(
                  height: 0,
                ),
                CustomTextInput(
                  hintText: 'Password',
                  leading: Icons.lock,
                  obscure: true,
                  userTyped: (val) {
                    password = val;
                  },
                ),
                SizedBox(
                  height: 30,
                ),
                Hero(
                  tag: 'loginbutton',
                  child: CustomButton(
                      text: 'login',
                      accentColor: Theme.of(context).accentColor,
                      mainColor: Theme.of(context).primaryColor,
                      onpress: () {}),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/signup');
                    },
                    child: Text(
                      'or create an account',
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
      // ),
    );
  }
}
