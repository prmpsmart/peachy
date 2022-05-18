import 'package:flutter/material.dart';
import 'ui/dialogs/camera.dart';
import 'ui/screens/create_user.dart';
import 'ui/screens/login.dart';
import 'ui/screens/peachy_home.dart';
import 'backend/client.dart';
import 'ui/ui_utils.dart';
import 'ui/screens/peachy_splash.dart';
import 'ui/screens/signup.'
    'dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Camera.staticLoad();

  runApp(
    PeachyApp(),
  );
}

class PeachyApp extends StatefulWidget {
  @override
  State<PeachyApp> createState() => _PeachyAppState();
}

class _PeachyAppState extends State<PeachyApp> {
  String initialRoute = '/splash';
  Client? client;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color primary = colorHex('#d85461');
    // primary = Colors.black;
    Color secondary = Color(0xFFFEF9EB);
    // secondary = Colors.black;
    MaterialColor primarySwatch = materialColor(primary);

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
          surface: Colors.green,
          onSurface: Colors.greenAccent,
          primaryVariant: primary.withBlue(100),
          secondaryVariant: secondary.withBlue(100),
        ),
        primarySwatch: primarySwatch,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: TextTheme(
          bodyText2: TextStyle(fontFamily: 'Times New Roman'),
          button: TextStyle(fontFamily: 'Times New Roman'),
        ),
      ),
      initialRoute: initialRoute,
      routes: {
        '/splash': (context) => PeachySplash(),
        '/home': (context) {
          var client = ModalRoute.of(context)!.settings.arguments as Client;
          return PeachyHome(client);
        },
        '/login': (context) {
          client = ModalRoute.of(context)!.settings.arguments as Client?;

          return PeachyLogin(client);
        },
        '/signup': (context) {
          client = ModalRoute.of(context)!.settings.arguments as Client?;

          return PeachySignUp(client);
        },
        '/createUser': (context) {
          bool showPop = false;
          var args = ModalRoute.of(context)?.settings.arguments;

          if (args is Client) {
            client = args;
            showPop = true;
          }

          return CreateUser(client, showPop);
        },
      },
    );
  }
}
