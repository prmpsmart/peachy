import 'package:flutter/material.dart';
import 'screens/create_user.dart';
import 'screens/login.dart';
import 'screens/peachy_screen.dart';
import 'backend/client.dart' as _client;
import 'constants.dart';
import 'screens/peachy_splash.dart';
import 'screens/signup.dart';


void main() {
  runApp(
    PeachyApp(),
  );
}

class PeachyApp extends StatefulWidget {
  @override
  State<PeachyApp> createState() => _PeachyAppState();
}

class _PeachyAppState extends State<PeachyApp> {
  _client.User? user;

  _client.Client? client;

  String initialRoute = '/splash';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color primary = colorHex('#d85461');
    Color secondary = Color(0xFFFEF9EB);

    Color primaryVariant = primary.withBlue(100);
    Color secondaryVariant = secondary.withBlue(100);

    return MaterialApp(
      title: 'Peachy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme(
          background: primary,
          onBackground: Colors.white,
          error: Colors.red,
          onError: Colors.white,
          primary: primary,
          onPrimary: Colors.white,
          secondary: secondary,
          onSecondary: primary,
          brightness: Brightness.light,
          surface: Colors.pink,
          onSurface: Colors.pinkAccent,
          primaryVariant: primaryVariant,
          secondaryVariant: secondaryVariant,
        ),
        primarySwatch: materialColor('#d85461'),
        // accentColor: secondary,
        textTheme: TextTheme(
          bodyText2: TextStyle(fontFamily: 'Times New Roman'),
        ),
      ),
      initialRoute: initialRoute,
      routes: {
        '/splash': (context) => PeachySplash(user),
        '/home': (context) {
          var list = ModalRoute.of(context)!.settings.arguments as List;
          return PeachyHome(list[0], list[1]);
        },
        '/login': (context) {
          client =
              ModalRoute.of(context)!.settings.arguments as _client.Client?;

          return PeachyLogin(client);
        },
        '/signup': (context) {
          client =
              ModalRoute.of(context)!.settings.arguments as _client.Client?;

          return PeachySignUp(client);
        },
        '/createUser': (context) {
          bool? isProfile = ModalRoute.of(context)!.settings.arguments as bool?;
          return CreateUser(isProfile ?? false);
        },
      },
    );
  }
}
