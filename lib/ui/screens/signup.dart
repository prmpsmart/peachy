// ignore_for_file: must_be_immutable

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:peachy/backend/client.dart';
import 'package:peachy/backend/constants.dart';
import '../ui_utils.dart';

class PeachySignUp extends P_StatefulWidget {
  Client? client;
  PeachySignUp(this.client);

  @override
  _PeachySignUpState createState() => _PeachySignUpState();
}

class _PeachySignUpState extends P_StatefulWidgetState<PeachySignUp>
    with SingleTickerProviderStateMixin {
  late AnimationController mainController;
  late Animation mainAnimation;

  late TextEditingController nameCont;
  late TextEditingController userCont;
  late TextEditingController passCont;

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

    nameCont = TextEditingController();
    userCont = TextEditingController();
    passCont = TextEditingController();

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
                  onPressed: () => setState(() {}),
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
                      if (userCont.text.isNotEmpty &&
                          passCont.text.isNotEmpty) {
                        client.signup(
                          userCont.text,
                          passCont.text,
                          name: nameCont.text,
                          receiver: (response) {
                            String toast = 'Login failed!';
                            bool succeed = RESPONSE['SUCCESSFUL'] == response;
                            if (succeed)
                              toast = 'Signup Successful!';
                            else if (RESPONSE['EXIST'] == response)
                              toast = 'Username already exist!';
                            peachyToast(context, toast, duration: 2000);
                            if (succeed) {
                              Navigator.pop(context);
                              Navigator.pushReplacementNamed(context, '/login',
                                  arguments: client);
                            }
                          },
                        );
                        peachyToast(context, 'Sent Signup!', duration: 1500);
                      } else
                        peachyToast(context, 'Username and Password required!',
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
