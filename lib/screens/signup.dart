import 'dart:async';

import 'package:flutter/material.dart';
import '../backend/client.dart';
import '../constants.dart';

class PeachySignUp extends StatefulWidget {
  Client? client;
  PeachySignUp(this.client);

  @override
  _PeachySignUpState createState() => _PeachySignUpState();
}

class _PeachySignUpState extends State<PeachySignUp>
    with SingleTickerProviderStateMixin {
  late AnimationController mainController;
  late Animation mainAnimation;

  String name = '';
  String username = '';
  String password = '';

  TextEditingController? nameCont;
  TextEditingController? userCont;
  TextEditingController? passCont;

  bool currentStatus = false;
  Timer? statusTimer;

  Client get client => widget.client as Client;

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

    nameCont = TextEditingController(text: name);
    userCont = TextEditingController(text: username);
    passCont = TextEditingController(text: password);

    statusTimer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (client.alive != currentStatus) {
        currentStatus = client.alive;
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    statusTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: Theme.of(context).colorScheme.secondary,
          height: MediaQuery.of(context).size.height,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                peachyLogo(context),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    client.alive ? 'Connected' : 'Not Connected',
                    style: TextStyle(
                        color: client.alive
                            ? Colors.green
                            : Theme.of(context).primaryColor),
                  ),
                ),
                CustomTextInput(
                  hintText: 'Name',
                  leading: Icons.text_format,
                  obscure: false,
                  controller: nameCont,
                ),
                SizedBox(
                  height: 0,
                ),
                CustomTextInput(
                  hintText: 'Username',
                  obscure: false,
                  leading: Icons.supervised_user_circle,
                  controller: userCont,
                ),
                SizedBox(height: 1),
                CustomTextInput(
                  hintText: 'Password',
                  leading: Icons.lock,
                  keyboard: TextInputType.visiblePassword,
                  obscure: true,
                  controller: passCont,
                ),
                SizedBox(height: 30),
                Hero(
                  tag: 'signupbutton',
                  child: CustomButton(
                    onpress: () {
                      if (username.isNotEmpty &&
                          password.isNotEmpty &&
                          name.isNotEmpty) {
                        print('signing up');
                        // var user = User(username, key: password, name: name);
                        // Navigator.pushReplacementNamed(context, '/home',
                        //     arguments: user);
                      } else
                        peachyToast(context, 'All fields are required!',
                            duration: 1500);
                    },
                    text: 'signup',
                    accentColor: Colors.white,
                    mainColor: Theme.of(context).primaryColor,
                  ),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/login',
                          arguments: client);
                    },
                    child: Text(
                      'or log in instead',
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          color: Theme.of(context).primaryColor),
                    )),
                SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                // peachyFooter(context)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
