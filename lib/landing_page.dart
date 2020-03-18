import 'package:ble_unlock/app/home/home_page.dart';
import 'package:ble_unlock/app/home/menu_page.dart';
import 'package:ble_unlock/app/sign_in/sign_in_page.dart';
import 'package:ble_unlock/services/auth.dart';
import 'package:ble_unlock/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return StreamBuilder<User>(
        stream: auth.onAuthStateChanged,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            User user = snapshot.data;
            // print(user.uid);
            if (user == null) {
              return SignInPage.create(context);
            }
            // return MenuPage();
            return Provider<User>.value(
              value: user,
              child: Provider<Database>(
                create: (_) => FirestoreDatabase(uid: user.uid),
                child: MenuPage(),
              ),
            );
            // return Provider<Database>(
            //   create: (_) => FirestoreDatabase(uid: user.uid),
            //   child: MenuPage(),
            // );
          } else {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
  }
}
