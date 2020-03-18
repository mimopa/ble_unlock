import 'package:ble_unlock/app/sign_in/apple_sign_in_available.dart';
import 'package:ble_unlock/landing_page.dart';
import 'package:ble_unlock/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

// void main() => runApp(new MyApp());
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // final appleSignInAvailable = await AppleSignInAvailable.check();
  // runApp(Provider<AppleSignInAvailable>.value(
  //   value: appleSignInAvailable,
  //   child: MyApp(),
  // ));
  runApp(MyApp());
  // new Routes();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<AuthBase>(
      create: (_) => Auth(),
      child: MaterialApp(
        title: 'BLE Unlock',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
            buttonColor: Colors.red,
            accentColor: Colors.green,
            canvasColor: Colors.white,
            textTheme: TextTheme(
              body1: TextStyle(color: Colors.black, fontSize: 18.0),
            )),
        home: LandingPage(),
      ),
    );
  }
}
