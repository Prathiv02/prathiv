import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prathivexample/provider/login_provider.dart';
import 'package:prathivexample/screens/last_login/last_login_screen.dart';
import 'package:prathivexample/screens/login/login_screen.dart';
import 'package:prathivexample/screens/plugin/plugin_screen.dart';
import 'package:provider/provider.dart';

import 'database/sp_util.dart';

late SpUtil sp;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  sp = await SpUtil.getInstance();
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  ).then((value) async {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => LoginProvider()),
      ],
      child: MaterialApp(
          title: 'Prathiv',
          theme: ThemeData(primarySwatch: Colors.blue),
          debugShowCheckedModeBanner: false,
          initialRoute: renderScreen(),
          routes: {
            PluginScreen.routeName: (context) => const PluginScreen(),
            LoginScreen.routeName: (context) => const LoginScreen(),
            LastLoginScreen.routeName: (context) => const LastLoginScreen(),
          }),
    );
  }
}

String renderScreen() {
  if (sp.getBool(SpUtil.loggedIn) != null) {
    if (sp.getBool(SpUtil.loggedIn)!) {
      return PluginScreen.routeName;
    } else {
      return LoginScreen.routeName;
    }
  } else {
    return LoginScreen.routeName;
  }
}
