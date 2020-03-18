import 'package:ble_unlock/app/home/end_confirm_page.dart';
import 'package:ble_unlock/common_widgets/platform_alert_dialog.dart';
import 'package:ble_unlock/landing_page.dart';
import 'package:ble_unlock/services/auth.dart';
import 'package:ble_unlock/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

class EndPage extends StatefulWidget {
  @override
  _EndPageState createState() => _EndPageState();
}

class _EndPageState extends State<EndPage> {
  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context);
      await auth.signOut();
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

  // パスコード
  String currentPassCode = "";

  void _passCodeChange(String newPassCode) {
    setState(() {
      currentPassCode = newPassCode;
      // print(currentPassCode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('利用終了'),
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
        body: _buldContents(context, currentPassCode, _passCodeChange),
      ),
    );
  }
}

Widget _buldContents(
    BuildContext context, String currentPassCode, Function passCodeChanged) {
  final database = Provider.of<Database>(context);

  return SingleChildScrollView(
    child: Container(
      padding: EdgeInsets.all(10.0),
      margin: EdgeInsets.all(20.0),
      width: double.infinity,
      child: Column(
        children: <Widget>[
          Text(
            '駐輪場料金確認',
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
          SizedBox(height: 40),
          Stack(children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Row(
                children: <Widget>[
                  Text(
                    'パスコード',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // SizedBox(width: 180),
                ],
              ),
            ),
            Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 2.0, horizontal: 80),
                child: PinCodeTextField(
                  length: 4,
                  obsecureText: false,
                  animationType: AnimationType.fade,
                  shape: PinCodeFieldShape.box,
                  animationDuration: Duration(milliseconds: 100),
                  borderRadius: BorderRadius.circular(5),
                  fieldHeight: 40,
                  fieldWidth: 30,
                  inactiveColor: Colors.grey,
                  onChanged: (value) => passCodeChanged(value),
                )),
          ]),
          SizedBox(height: 40),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[400],
            ),
            padding: EdgeInsets.only(
              left: 10.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 30),
                Text(
                  '自身の利用状況の確認、決済画面への移動は',
                  style: TextStyle(fontSize: 15),
                ),
                RichText(
                  text: TextSpan(
                      style: TextStyle(fontSize: 15, color: Colors.black),
                      children: [
                        TextSpan(text: '設定した'),
                        TextSpan(
                          text: '四桁のパスコードによる認証',
                          style: TextStyle(color: Colors.red),
                        ),
                        TextSpan(text: 'が必要'),
                      ]),
                ),
                Text(
                  'です。',
                  style: TextStyle(fontSize: 15),
                ),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 45.0),
                  child: SizedBox(
                    width: 210,
                    height: 40,
                    child: RaisedButton(
                      child: Text(
                        "パスコードの確認",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      color: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(2.0),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              // return EndConfirmPage();
                              return Provider<Database>.value(
                                value: database,
                                child: EndConfirmPage(),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 50,
          ),
          SizedBox(
            width: 210,
            height: 40,
            child: RaisedButton(
              child: Text(
                "前のページに戻る",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                ),
              ),
              color: Colors.grey,
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(2.0),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    ),
  );
}
