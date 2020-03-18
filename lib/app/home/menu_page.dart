import 'package:ble_unlock/app/home/end_page.dart';
import 'package:ble_unlock/app/home/home_page.dart';
import 'package:ble_unlock/common_widgets/platform_alert_dialog.dart';
import 'package:ble_unlock/landing_page.dart';
import 'package:ble_unlock/services/auth.dart';
import 'package:ble_unlock/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MenuPage extends StatelessWidget {
  Future<void> _signOut(BuildContext context) async {
    try {
      print('SignOut-S!');
      final auth = Provider.of<AuthBase>(context);
      await auth.signOut();
      print('SignOut!');
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return LandingPage();
          },
        ),
      );
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final didRequestSignOut = await PlatformAlertDialog(
      title: 'Logout',
      content: 'Are you sure that you want to logout?',
      cancelActionText: 'Cancel',
      defaultActionText: 'Logout',
    ).show(context);
    if (didRequestSignOut == true) {
      _signOut(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Dabaseへの参照
    final database = Provider.of<Database>(context);
    // database.getParking('F1FDE7B2-F3BA-3259-C1A5-7BC2943A8B81').then((value) {
    //   print(value.keyId);
    // });
    return Scaffold(
      appBar: AppBar(
        title: Text('利用開始'),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Logout',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
              ),
            ),
            onPressed: () => _confirmSignOut(context),
          ),
        ],
      ),
      body: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          padding: EdgeInsets.all(10.0),
          margin: EdgeInsets.all(20.0),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                '駐輪機メニュー',
                style: TextStyle(
                  fontSize: 19.0,
                  color: Colors.black,
                ),
              ),
              Divider(
                color: Colors.black,
                indent: 10,
                endIndent: 10,
              ),
              SizedBox(
                height: 20,
              ),
              Text('利用メニューを選択してください。'),
              SizedBox(
                height: 140,
              ),
              SizedBox(
                width: 220,
                height: 60,
                child: RaisedButton(
                  child: Text(
                    "利用開始",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  color: Colors.black54,
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(10.0),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder: (context) {
                          // return HomePage();
                          return Provider<Database>.value(
                            value: database,
                            child: HomePage(),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 220,
                height: 60,
                child: RaisedButton(
                  child: Text(
                    "利用終了",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  color: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(10.0),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder: (context) {
                          // return EndPage();
                          return Provider<Database>.value(
                            value: database,
                            child: EndPage(),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
