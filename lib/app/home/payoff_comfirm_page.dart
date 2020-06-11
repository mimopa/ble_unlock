import 'package:ble_unlock/app/home/end_peyoff_page.dart';
import 'package:ble_unlock/common_widgets/areaParkingName_widget.dart';
import 'package:ble_unlock/common_widgets/platform_alert_dialog.dart';
import 'package:ble_unlock/landing_page.dart';
import 'package:ble_unlock/services/auth.dart';
import 'package:ble_unlock/services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:provider/provider.dart';

import 'end_confirm_page.dart';

class PayOffComfirmPage extends StatelessWidget {
  const PayOffComfirmPage({
    Key key,
    this.device,
    this.openKey,
    this.keyId,
    this.areaDefaultValue,
    this.parkDefaultValue,
  }) : super(key: key);

  final BluetoothDevice device;
  final String openKey;
  final String keyId;
  final String areaDefaultValue;
  final String parkDefaultValue;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('利用料精算'),
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
        body: _buldContents(
          context,
          device,
          openKey,
          keyId,
          areaDefaultValue,
          parkDefaultValue,
        ),
      ),
    );
  }
}

Widget _buldContents(
  BuildContext context,
  BluetoothDevice device,
  String openKey,
  String keyId,
  String areaDefaultValue,
  String parkDefaultValue,
) {
  final database = Provider.of<Database>(context);

  final areaParkingName = AreaParkingName();
  var textSpan = TextSpan(
    text: keyId,
    style: TextStyle(
      fontSize: 30,
      fontWeight: FontWeight.bold,
    ),
  );
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
          SizedBox(
            height: 10,
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            padding: EdgeInsets.only(
              left: 18.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 50),
                  child: RichText(
                    text: TextSpan(
                        style: TextStyle(fontSize: 15, color: Colors.black),
                        children: [
                          TextSpan(text: '駐輪場No '),
                          TextSpan(
                            text: areaDefaultValue + " - " + parkDefaultValue,
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ]),
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 100),
                  child: Row(
                    children: [
                      areaParkingName.areaName(context, areaDefaultValue,
                          fontSize: 15, isRich: true),
                      SizedBox(width: 5),
                      areaParkingName.parkName(
                          context, areaDefaultValue, parkDefaultValue,
                          fontSize: 15, isRich: true),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 50),
                  child: RichText(
                    text: TextSpan(
                        style: TextStyle(fontSize: 15, color: Colors.black),
                        children: [
                          TextSpan(text: '駐輪キーNo '),
                          textSpan,
                        ]),
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 50),
                  child: RichText(
                    text: TextSpan(
                        style: TextStyle(fontSize: 15, color: Colors.black),
                        children: [
                          TextSpan(text: '利用開始時間 '),
                          TextSpan(
                            text: '14',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(text: '： '),
                          TextSpan(
                            text: '21',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ]),
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 50),
                  child: RichText(
                    text: TextSpan(
                        style: TextStyle(fontSize: 15, color: Colors.black),
                        children: [
                          TextSpan(text: '利用時間 '),
                          TextSpan(
                            text: '3',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(text: '時間'),
                          TextSpan(
                            text: '12',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(text: '分'),
                        ]),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 40.0),
                  child: SizedBox(
                    width: 210,
                    height: 40,
                    child: RaisedButton(
                      child: Text(
                        "キャンセル",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      color: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(2.0),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              // return EndConfirmPage(
                              //   areaDefaultValue: areaDefaultValue,
                              //   parkDefaultValue: parkDefaultValue,
                              // );
                              return Provider<Database>.value(
                                value: database,
                                child: EndConfirmPage(
                                  areaDefaultValue: areaDefaultValue,
                                  parkDefaultValue: parkDefaultValue,
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[300],
            ),
            padding: EdgeInsets.only(
              left: 10.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 20),
                Text(
                  '駐輪キーナンバーを間違えて自分以外のロックキーを解',
                  style: TextStyle(fontSize: 12),
                ),
                RichText(
                  text: TextSpan(
                      style: TextStyle(fontSize: 12, color: Colors.black),
                      children: [
                        TextSpan(text: '錠してしまった場合の'),
                        TextSpan(
                          text: 'ご返金の対応は致しかねます。',
                          style: TextStyle(fontSize: 13, color: Colors.red),
                        ),
                      ]),
                ),
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 45.0),
                  child: SizedBox(
                    width: 210,
                    height: 40,
                    child: RaisedButton(
                      child: Text(
                        "決済画面へ移動する",
                        style: TextStyle(
                          fontSize: 13,
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
                              // return EndPayOffPage(
                              //   device: device,
                              //   openKey: openKey,
                              //   keyId: keyId,
                              //   areaDefaultValue: areaDefaultValue,
                              //   parkDefaultValue: parkDefaultValue,
                              // );
                              return Provider<Database>.value(
                                value: database,
                                child: EndPayOffPage(
                                  device: device,
                                  openKey: openKey,
                                  keyId: keyId,
                                  areaDefaultValue: areaDefaultValue,
                                  parkDefaultValue: parkDefaultValue,
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
